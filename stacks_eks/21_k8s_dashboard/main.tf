locals {
  name = "kubernetes-dashboard"
  set_list = [
    {
      name  = "service.externalPort"
      value = "9090"
    },
    {
      name  = "protocolHttp"
      value = true
    },
    {
      name  = "extraArgs"
      value = "{--enable-skip-login,--enable-insecure-login,--disable-settings-authorizer,--insecure-bind-address=0.0.0.0}"
    },
    {
      name  = "rbac.clusterReadOnlyRole"
      value = true
    },
    {
      name  = "metricsScraper.enabled"
      value = true
    },
    {
      name  = "resources.requests.cpu"
      value = "2"
    },
    {
      name  = "resources.requests.memory"
      value = "200Mi"
    },
    {
      name  = "resources.limits.cpu"
      value = "2"
    },
    {
      name  = "resources.limits.memory"
      value = "200Mi"
    }
  ]
}

resource "helm_release" "main" {
  name       = local.name
  chart      = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  version    = "6.0.0"
  namespace  = "kubernetes-dashboard"

  dynamic "set" {
    for_each = local.set_list
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}

