module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.private_subnet_ids
  vpc_id          = var.vpc_id

  enable_irsa = true

  tags = var.tags
}
