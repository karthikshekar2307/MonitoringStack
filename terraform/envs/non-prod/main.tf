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
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  manage_aws_auth_configmap = true
  create_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::896553234455:user/karthikcli"
      username = "karthikcli"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::896553234455:role/EKSMonGitOIDC"
      username = "github-actions"
      groups   = ["system:masters"]
    }
  ]

  tags = var.tags
}

  
module "nodegroups" {
  source             = "../../modules/nodegroups"
  cluster_name       = module.eks.cluster_name
  cluster_version    = "1.29"
  private_subnet_ids = module.vpc.private_subnets
  tags               = var.tags

  cluster_service_cidr = "172.20.0.0/16"

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

module "argocd" {
  source    = "../../modules/argocd"
  namespace = "argocd"
}
