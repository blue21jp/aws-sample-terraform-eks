locals {
  name = "external-secrets"
  set_list = [
    {
      name  = "metrics.enabled"
      value = false
    }
  ]
}

resource "helm_release" "main" {
  name       = local.name
  chart      = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  version    = "3.8.2"
  namespace  = "kube-system"

  dynamic "set" {
    for_each = local.set_list
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}
