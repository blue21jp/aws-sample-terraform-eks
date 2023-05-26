locals {
  name = "aws-load-balancer-controller"
  set_list = [
    {
      name  = "clusterName"
      value = data.aws_eks_cluster.main.id
    },
    {
      name  = "image.repository"
      value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller"
    },
    {
      name  = "image.tag"
      value = "v2.4.2"
    },
    {
      name  = "replicaCount"
      value = 1
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.aws_load_balancer_controller.arn
    },
    {
      # EKS Fargate specific
      name  = "region"
      value = data.aws_region.current.name
    },
    {
      name  = "vpcId"
      value = data.aws_vpc.main.id
    }
  ]
}

resource "helm_release" "main" {
  name       = local.name
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.4.1"
  namespace  = "kube-system"

  dynamic "set" {
    for_each = local.set_list
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}
