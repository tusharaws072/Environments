
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-${var.stage_name}-ec2-sg"
  description = "EC2 security group"
  vpc_id      = var.vpc_id

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow PostgreSQL access
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


################################   ALB ######################



resource "aws_security_group" "alb" {
  vpc_id =var.vpc_id
  name        = "${var.project_name}-${var.stage_name}-alb-sg"
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  tags = {
    Name = "${var.project_name}-${var.stage_name}-alb-sg"
  }
}



###########    EKS SECURITY GROUP ################


resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = var.vpc_id  # ✅ Use the variable instead of module.vpc
}

resource "aws_security_group_rule" "all_worker_mgmt_ingress" {
  description       = "Allow inbound traffic from EKS"
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
  security_group_id = aws_security_group.all_worker_mgmt.id
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

resource "aws_security_group_rule" "all_worker_mgmt_egress" {
  description       = "Allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.all_worker_mgmt.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}







resource "aws_security_group" "worker_sg" {
  name        = "${var.project_name}-${var.stage_name}-worker-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.project_name}-${var.stage_name}-worker-sg"
    Project = var.project_name
    Stage   = var.stage_name
  }
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.project_name}-${var.stage_name}-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.project_name}-${var.stage_name}-eks-cluster-sg"
    Project = var.project_name
    Stage   = var.stage_name
  }
}

# ✅ Allow worker nodes to communicate with the EKS control plane (API server)
resource "aws_security_group_rule" "eks_nodes_to_control_plane" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
}

# ✅ Allow nodes to communicate with each other
resource "aws_security_group_rule" "eks_worker_nodes_internal" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_sg.id
  source_security_group_id = aws_security_group.worker_sg.id
}

# ✅ Allow worker nodes outbound internet access (for pulling images, updates)
resource "aws_security_group_rule" "eks_nodes_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol         = "-1"
  security_group_id = aws_security_group.worker_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
