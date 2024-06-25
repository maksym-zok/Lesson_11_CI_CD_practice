resource "aws_lb_target_group" "main" {
  name     = "mhlyva"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path    = "/v1/auth/login"
    matcher = "404"
  }
}

resource "aws_acm_certificate" "main" {
  domain_name               = "*.mhlyva.sid24.xyz"
  subject_alternative_names = ["mhlyva.sid24.xyz"]
  validation_method         = "DNS"
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_cname : record.fqdn]
}

resource "aws_route53_record" "cert_cname" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

resource "aws_route53_record" "a_type" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "mhlyva.sid24.xyz"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "db_cname" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "db.mhlyva.sid24.xyz"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.main.address]
}

resource "aws_lb" "main" {
  name               = "mhlyva"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = [for subnet in aws_subnet.main : subnet.id]
  tags               = var.tags
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}