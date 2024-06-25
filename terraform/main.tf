module "tenant" {
  source               = "./modules/tenant"
  vpc_cidr_block       = var.vpc_cidr_block
  tags                 = var.tags
  instance_type        = var.instance_type
  aws_db_instance_pass = var.aws_db_instance_pass
}