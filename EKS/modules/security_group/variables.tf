variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "stage_name" {
  description = "Deployment stage name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}
