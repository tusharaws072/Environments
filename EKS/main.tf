module "vpc" {
  source                     = "./modules/vpc"
  region                     = var.region
  project_name               = var.project_name
  vpc_cidr                   = var.vpc_cidr
  nat_destination_cidr_block = var.nat_destination_cidr_block
  stage_name                 = var.stage_name
  allowed_db_cidrs           = ["10.0.0.0/16"] 
}





module "ec2" {
  source            = "./modules/ec2"
  project_name      = var.project_name
  stage_name        = var.stage_name
  ec2_instance_type = var.ec2_instance_type
  ec2_public_subnet = module.vpc.public_subnets[0]
  ec2_sg            = module.security_group.ec2_sg_id
  ami_id            = var.ami_id

}


module "load_balancer" {
  source       = "./modules/load_balancer"
  depends_on   = [module.ec2]
  project_name = var.project_name
  stage_name   = var.stage_name
  vpc_id       = module.vpc.vpc_id
  alb_cidr     = module.vpc.public_subnet_ids
  target_type  = var.target_type
  target_id    = module.ec2.instance_id[0]
  server_sg_id = module.security_group.alb_sg
}



module "security_group" {
  source       = "./modules/security_group"
  project_name = var.project_name
  stage_name   = var.stage_name
  vpc_id       = module.vpc.vpc_id
}


module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  stage_name   = var.stage_name
}


module "eks" {
  source                    = "./modules/eks"
  project_name              = var.project_name
  stage_name                = var.stage_name
  kubernetes_version        = "1.29"
  vpc_id                    = module.vpc.vpc_id
  private_subnets           = module.vpc.private_subnets
  worker_security_group_ids = [module.security_group.worker_sg_id]
  eks_worker_role_arn       = module.iam.eks_worker_role_arn
}
