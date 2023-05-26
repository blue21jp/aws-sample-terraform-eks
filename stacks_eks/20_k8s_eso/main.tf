locals {
  name = "external-secrets"
  set_list = [
    {
      name  = "clusterName"
      value = data.aws_eks_cluster.main.id
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.eso.arn
    },
    {
      name  = "installCRDs"
      value = true
    },
    {
      # EKS Fargate specific
      name  = "region"
      value = "us-east-1"
    },
    {
      name  = "vpcId"
      value = data.aws_vpc.main.id
    },
    {
      name  = "webhook.port"
      value = "9443"
    }
  ]
}

resource "helm_release" "main" {
  name          = local.name
  chart         = "external-secrets"
  repository    = "https://charts.external-secrets.io"
  version       = "0.7.0"
  namespace     = "external-secrets"
  wait_for_jobs = true

  dynamic "set" {
    for_each = local.set_list
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}

resource "kubectl_manifest" "cluster_secret_store" {
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: ssm-secret-store
  namespace: external-secrets
spec:
  provider:
    aws:
      service: ParameterStore
      region: ${data.aws_region.current.name}
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets
            namespace: external-secrets
YAML

  depends_on = [
    helm_release.main
  ]
}
