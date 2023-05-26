locals {
  namespace = "app"
  alb_list = {
    app1 = {
      name     = "${local.common_all.project}-nginx"
      svc_name = "nginx-service"
      port     = 80
    }
    app2 = {
      name     = "${local.common_all.project}-php"
      svc_name = "php-service"
      port     = 80
    }
  }
}

resource "kubernetes_ingress_v1" "main" {
  for_each = local.alb_list

  metadata {
    name      = each.value.name
    namespace = local.namespace
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      # subnetのTAGで自動設定する
      #"alb.ingress.kubernetes.io/subnets"          = join(",", data.aws_subnet.public.*.id)
      "alb.ingress.kubernetes.io/security-groups"  = aws_security_group.app_alb_sg.id
      "alb.ingress.kubernetes.io/group.name"       = each.value.name
      "alb.ingress.kubernetes.io/healthcheck-path" = "/"
    }
  }

  spec {
    ingress_class_name = "alb"
    default_backend {
      service {
        name = each.value.svc_name
        port {
          number = each.value.port
        }
      }
    }
  }
}

resource "aws_security_group" "app_alb_sg" {
  name        = "${local.common_all.project}-app-alb-sg"
  description = "${local.common_all.project}-app-alb-sg"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_security_group_rule" "app_alb_sg_egress" {
  security_group_id = aws_security_group.app_alb_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_alb_sg_ingress" {
  security_group_id = aws_security_group.app_alb_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${data.external.myip_pub.result["ip"]}/32"]
}
