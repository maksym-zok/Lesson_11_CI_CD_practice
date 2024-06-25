resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_subnet" "main" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags              = var.tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags
}

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "main" {
  for_each       = aws_subnet.main
  subnet_id      = each.value.id
  route_table_id = aws_route_table.internet.id
}

resource "aws_security_group" "main" {
  name        = "maksym-hlyva"
  description = "General security group"
  vpc_id      = aws_vpc.main.id
  tags        = var.tags

  dynamic "egress" {
    for_each = toset(var.egress_rules)
    content {
      from_port   = egress.value.port
      protocol    = egress.value.protocol
      to_port     = egress.value.port
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  dynamic "ingress" {
    for_each = toset(var.ingress_rules)
    content {
      from_port   = ingress.value.port
      protocol    = ingress.value.protocol
      to_port     = ingress.value.port
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
      self        = ingress.value.self
    }
  }
}