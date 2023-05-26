locals {
  name = "argocd"
  set_list = [
    {
      name  = "server.extraArgs"
      value = "{--insecure}"
    }
  ]
}

resource "helm_release" "main" {
  name       = local.name
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.16.9"
  namespace  = "argocd"

  dynamic "set" {
    for_each = local.set_list
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [
    kubectl_manifest.argocd_external_secret
  ]
}

resource "kubectl_manifest" "argocd_external_secret" {
  yaml_body = templatefile("k8s_external_secret.yaml", {
    namespace           = "argocd"
    git_ssh_private_key = local.common_all.git_info.ssm_ssh_private_key
  })
}
