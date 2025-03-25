module "vpc" {
  source          = "../../modules/vpc"
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

module "eks" {
  source             = "../../modules/eks"
  cluster_name       = "nonprod-monitoring-eks"
  cluster_version    = "1.29"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  tags               = var.tags
}
