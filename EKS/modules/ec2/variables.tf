variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "stage_name" {
  description = "Deployment stage name"
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "ec2_public_subnet" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "ec2_sg" {
  description = "Security group ID assigned to the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}



# variable "ec2_instance_count" {
#   description = "Number of EC2 instances to create"
#   type        = number
#   default     = 2  # Default is 2 instances
# }

###
