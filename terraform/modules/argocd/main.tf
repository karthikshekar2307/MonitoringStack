resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = var.chart_version

  values = [
    yamlencode({
      controller = {
        nodeSelector = {
          "workload" = "argocd"
        }
        tolerations = [{
          key      = "dedicated"
          value    = "argocd"
          effect   = "NoSchedule"
        }]
      }
      server = {
        nodeSelector = {
          "workload" = "argocd"
        }
        tolerations = [{
          key      = "dedicated"
          value    = "argocd"
          effect   = "NoSchedule"
        }]
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.argocd]
}
