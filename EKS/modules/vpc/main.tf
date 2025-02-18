# Fetch availability zones dynamically
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-${var.stage_name}-vpc"
  cidr = var.vpc_cidr

  # Use dynamically fetched availability zones
  azs             = data.aws_availability_zones.available.names
  public_subnets  = [for i in range(length(data.aws_availability_zones.available.names)) : cidrsubnet(var.vpc_cidr, 4, i)]
  private_subnets = [for i in range(length(data.aws_availability_zones.available.names)) : cidrsubnet(var.vpc_cidr, 4, i + 10)]

  # Disable NAT Gateway creation by the module
  enable_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name        = var.project_name
    Environment = var.stage_name
  }
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_gateway" {
  vpc = true

  tags = {
    Name        = "${var.project_name}-${var.stage_name}-nat-eip"
    Environment = var.stage_name
  }
}

# Create the NAT Gateway manually
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = module.vpc.public_subnets[0]

  tags = {
    Name        = "${var.project_name}-${var.stage_name}-nat-gateway"
    Environment = var.stage_name
  }
}

# Add a route to the private route table to use the NAT Gateway
resource "aws_route" "private_to_nat" {
  route_table_id         = module.vpc.private_route_table_ids[0] # First private route table
  destination_cidr_block = var.nat_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# Create an S3 Gateway VPC Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  # Attach the endpoint to both public and private route tables
  route_table_ids = concat(
    module.vpc.public_route_table_ids,
    module.vpc.private_route_table_ids
  )

  tags = {
    Name        = "${var.project_name}-${var.stage_name}-s3-vpc-endpoint"
    Environment = var.stage_name
  }
}

# ✅ Added: Define the DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.stage_name}-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name        = "${var.project_name}-${var.stage_name}-db-subnet-group"
    Environment = var.stage_name
  }
}
