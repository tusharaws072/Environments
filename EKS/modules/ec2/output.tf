output "ec2_key_name" {
  value = aws_key_pair.ec2.key_name
}

output "ssh_private_key" {
  value = aws_secretsmanager_secret_version.private_key_version.secret_string
}

output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}






# output "instance_id" {
#   description = "The ID of the EC2 instance"
#   value       = module.ec2_instance.id  # ✅ Correct if using an EC2 module
# }



output "instance_id" {
  description = "List of EC2 Instance IDs"
  value       = module.ec2_instance[*].id  # Returns a list
}
