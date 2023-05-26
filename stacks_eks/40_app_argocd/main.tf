locals {
  app_list = {
    app1 = local.common_all.app1
    app2 = local.common_all.app2
  }
}

resource "kubectl_manifest" "argo_app" {
  for_each = local.app_list

  yaml_body = templatefile("k8s_argo_app.yaml", {
    name      = each.value.app_name
    namespace = "argocd"
    project   = each.value.app_project
    repo_url  = each.value.repository
    path      = each.value.app_path
    rev       = each.value.rev
  })
}
