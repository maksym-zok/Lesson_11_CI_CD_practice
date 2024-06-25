resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "mhlyva-rds-subnet-group"
  subnet_ids = [for subnet in aws_subnet.main : subnet.id]
}

resource "aws_db_parameter_group" "main" {
  name   = "mhlyva"
  family = "postgres15"

  parameter {
    name  = "rds.force_ssl"
    value = 0
  }
}

resource "aws_db_instance" "main" {
  allocated_storage      = 10
  db_name                = "mhlyva_rds"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.t4g.micro"
  username               = "postgres"
  password               = random_password.password.result
  vpc_security_group_ids = [aws_security_group.main.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  parameter_group_name   = aws_db_parameter_group.main.name
  apply_immediately      = true
  skip_final_snapshot    = true
  tags                   = var.tags
}