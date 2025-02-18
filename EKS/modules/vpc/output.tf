








output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}







output "rds_subnet_ids" {
  description = "List of RDS Subnet IDs"
  value       = module.vpc.private_subnets  # ✅ Correct reference
}



########################-----
output "public_subnet_ids" {
  value = module.vpc.public_subnets
}




output "ec2_subnet" {
  value = module.vpc.public_subnets[1]
  
}
