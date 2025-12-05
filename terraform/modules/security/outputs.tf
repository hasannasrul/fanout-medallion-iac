output "rds_sg_id" {
  description = "RDS security group ID (optional, for VPC Lambda deployment)"
  value       = try(aws_security_group.rds_sg[0].id, "")
}

output "rds_sg_name" {
  description = "RDS security group name"
  value       = try(aws_security_group.rds_sg[0].name, "")
}
