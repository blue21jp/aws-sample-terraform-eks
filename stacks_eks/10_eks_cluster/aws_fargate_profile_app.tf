resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

resource "kubernetes_namespace" "kubernetes_dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  }
}

resource "aws_eks_fargate_profile" "ops" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "ops"
  pod_execution_role_arn = aws_iam_role.eks-fargate-profile.arn

  # These subnets must have the following resource tag:
  # kubernetes.io/cluster/<CLUSTER_NAME>.
  subnet_ids = data.aws_subnet.private[*].id

  selector {
    namespace = "external-secrets"
  }
  selector {
    namespace = "kubernetes-dashboard"
  }
  selector {
    namespace = "argocd"
  }
}

resource "aws_eks_fargate_profile" "app" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "app"
  pod_execution_role_arn = aws_iam_role.eks-fargate-profile.arn

  # These subnets must have the following resource tag:
  # kubernetes.io/cluster/<CLUSTER_NAME>.
  subnet_ids = data.aws_subnet.private[*].id

  selector {
    namespace = "app"
  }
}
