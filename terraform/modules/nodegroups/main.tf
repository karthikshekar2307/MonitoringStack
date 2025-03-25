module "node_groups" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.8.5"

  for_each = var.node_groups

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.private_subnet_ids
  cluster_service_cidr    = var.cluster_service_cidr

  name            = each.key
  instance_types  = each.value.instance_types
  desired_size    = each.value.desired_size
  max_size        = each.value.max_size
  min_size        = each.value.min_size
  labels          = each.value.labels
  taints          = each.value.taints

  tags = var.tags
}