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

module "nodegroups" {
  source             = "../../modules/nodegroups"
  cluster_name       = module.eks.cluster_name
  cluster_version    = "1.29"
  private_subnet_ids = module.vpc.private_subnets
  tags               = var.tags

  node_groups = {
    argocd = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      labels = {
        workload = "argocd"
      }
      taints = [{
        key    = "dedicated"
        value  = "argocd"
        effect = "NO_SCHEDULE"
      }]
    }

    grafana = {
      instance_types = ["t3.large"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      labels = {
        workload = "grafana"
      }
      taints = [{
        key    = "dedicated"
        value  = "grafana"
        effect = "NO_SCHEDULE"
      }]
    }

    prometheus = {
      instance_types = ["m5.xlarge"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      labels = {
        workload = "prometheus"
      }
      taints = [{
        key    = "dedicated"
        value  = "prometheus"
        effect = "NO_SCHEDULE"
      }]
    }
  }
}

