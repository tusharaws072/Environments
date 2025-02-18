output "eks_worker_role_arn" {
  description = "IAM Role ARN for EKS worker nodes"
  value       = aws_iam_role.eks_worker_role.arn
}


