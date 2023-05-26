resource "kubernetes_ingress_v1" "main" {

  metadata {
    name      = "${local.common_all.project}-kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      # subnetのTAGで自動設定する
      #"alb.ingress.kubernetes.io/subnets"          = join(",", data.aws_subnet.public.*.id)
      "alb.ingress.kubernetes.io/security-groups"  = aws_security_group.eks_dashboard_alb_sg.id
      "alb.ingress.kubernetes.io/group.name"       = "${local.common_all.project}-k8s-dashboard"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/"
    }
  }

  spec {
    ingress_class_name = "alb"
    default_backend {
      service {
        name = "kubernetes-dashboard"
        port {
          number = 9090
        }
      }
    }
  }

}

resource "aws_security_group" "eks_dashboard_alb_sg" {
  name        = "${local.common_all.project}-eks-dashboard-alb-sg"
  description = "${local.common_all.project}-eks-dashboard-alb-sg"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_security_group_rule" "eks_dashboard_alb_sg_egress" {
  security_group_id = aws_security_group.eks_dashboard_alb_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks_dashboard_alb_sg_ingress" {
  security_group_id = aws_security_group.eks_dashboard_alb_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${data.external.myip_pub.result["ip"]}/32"]
}
