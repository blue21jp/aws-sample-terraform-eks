data "kubernetes_secret" "ssm" {
  metadata {
    name      = "argocd-external-secret"
    namespace = "argocd"
  }
  depends_on = [
    helm_release.main,
  ]
}

resource "kubectl_manifest" "repo" {
  yaml_body = templatefile("k8s_repo.yaml", {
    name                = local.common_all.app1.repo_name
    namespace           = "argocd"
    repository          = local.common_all.app1.repository
    ssh_private_key_b64 = data.kubernetes_secret.ssm.data.ssh_private_key
  })
}
