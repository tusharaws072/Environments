variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1" # Singapore region
}

variable "access_key" {
  description = "AWS access key for authentication."
  type        = string
  sensitive   = true
  default     = ""
}

variable "secret_key" {
  description = "AWS secret key for authentication."
  type        = string
  sensitive   = true
  default     = ""
}



variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my-project"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "nat_destination_cidr_block" {
  description = "The CIDR block for NAT destination"
  type        = string
  default     = "0.0.0.0/0"
}

variable "stage_name" {
  description = "The environment stage (e.g., dev, staging, prod)"
  type        = string
  default     = "staging"
}




variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0672fd5b9210aa093"
}




variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.27" # Update to the required version
}





variable "target_type" {
  default = "instance"

}