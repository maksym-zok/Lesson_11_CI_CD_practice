resource "aws_launch_template" "main" {
  name = var.tags.Name

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = var.root_disk_size
    }
  }

  ebs_optimized = true

  image_id = data.aws_ami.ubuntu22.id

  instance_type = var.instance_type

  key_name = "mhlyva"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main.id]
  }

  user_data = filebase64("${path.module}/user-data.sh")

  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "aws_autoscaling_group" "main" {
  name             = var.tags.Name
  max_size         = 5
  min_size         = 1
  desired_capacity = 1
  force_delete     = true

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.main.arn]

  vpc_zone_identifier = [for subnet in aws_subnet.main : subnet.id]
  depends_on          = [aws_db_instance.main]
}