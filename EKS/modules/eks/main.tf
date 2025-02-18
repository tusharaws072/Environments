module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.19.1"

  cluster_name    = "${var.project_name}-${var.stage_name}-eks"
  cluster_version = var.kubernetes_version
  subnet_ids      = var.private_subnets
  enable_irsa     = true
  cloudwatch_log_group_retention_in_days = 0  

  vpc_id = var.vpc_id  

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    node_group = {
      name         = "${var.project_name}-${var.stage_name}-ng"
      min_size     = 2
      max_size     = 6
      desired_size = 2
      iam_role_arn = var.eks_worker_role_arn

      # ✅ Attach correct security group to nodes
      vpc_security_group_ids = var.worker_security_group_ids

      tags = {
        Name  = "${var.project_name}-${var.stage_name}-ng"
        Stage = var.stage_name
      }
    }
  }

  tags = {
    Name    = "${var.project_name}-${var.stage_name}-eks-cluster"
    Project = var.project_name
    Stage   = var.stage_name
    Cluster = "${var.project_name}-${var.stage_name}"
  }
}
