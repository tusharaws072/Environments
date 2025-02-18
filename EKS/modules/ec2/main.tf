# Generate a key pair dynamically
resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create a key pair in AWS using the generated public key
resource "aws_key_pair" "ec2" {
  key_name   = "${var.project_name}-${var.stage_name}-ec2-key001900"
  public_key = tls_private_key.ec2.public_key_openssh
}

# Store the private key securely in AWS Secrets Manager
resource "aws_secretsmanager_secret" "private_key" {
  name        = "${var.project_name}-${var.stage_name}-ec2-private-key001900"
  description = "Private key for SSH access to the EC2 instance"
}

resource "aws_secretsmanager_secret_version" "private_key_version" {
  secret_id     = aws_secretsmanager_secret.private_key.id
  secret_string = tls_private_key.ec2.private_key_pem
}

# Launch the EC2 instance
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami           = var.ami_id
  name          = "${var.project_name}-${var.stage_name}-ec2"
  instance_type = var.ec2_instance_type
  monitoring    = true

  vpc_security_group_ids = [var.ec2_sg]
  subnet_id              = var.ec2_public_subnet
  key_name               = aws_key_pair.ec2.key_name

  associate_public_ip_address = true

  root_block_device = [
    {
      volume_size           = 15   # Set the root volume size to 30 GB
      volume_type           = "gp3" # General Purpose SSD
      delete_on_termination = true  # Automatically delete volume on termination
    }
  ]

  tags = {
    Name        = "${var.project_name}-${var.stage_name}-ec2"
    Environment = var.stage_name
  }
}
