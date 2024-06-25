output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "app_url" {
  description = "Application URL"
  value       = "https://${aws_route53_record.a_type.fqdn}"
}

output "db_pass" {
  value       = aws_db_instance.main.password
}