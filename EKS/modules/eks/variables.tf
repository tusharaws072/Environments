variable "project_name" {
  description = "Project name"
  type        = string
}

variable "stage_name" {
  description = "Stage name (dev, staging, prod)"
  type        = string
}



variable "kubernetes_version" {
  default     = 1.27
  description = "kubernetes version"
}


variable "worker_security_group_ids" {
  description = "List of security group IDs for EKS worker nodes"
  type        = list(string)
}



variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for EKS cluster"
  type        = list(string)
}





variable "eks_worker_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  type        = string
}
