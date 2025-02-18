





output "alb_sg" {
    value = aws_security_group.alb.id
  
}


output "worker_sg_id" {
  description = "The ID of the EKS worker node security group"
  value       = aws_security_group.worker_sg.id
}



output "ec2_sg_id" {
  value = aws_security_group.ec2.id
}