output "vpc_id" {
  description = "ID of the VPC"
  value       = module.tenant.vpc_id
}

output "app_url" {
  description = "Application URL"
  value       = module.tenant.app_url
}

output "db_pass" {
  value       = module.tenant.db_pass
  sensitive   = true
}