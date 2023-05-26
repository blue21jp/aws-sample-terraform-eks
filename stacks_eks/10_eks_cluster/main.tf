resource "aws_eks_cluster" "main" {
  name     = local.common_all.eks_cluster_name
  version  = "1.24"
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {

    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = concat(
      data.aws_subnet.public[*].id,
      data.aws_subnet.private[*].id
    )
  }

  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy]
}

resource "aws_iam_role" "eks-cluster" {
  name = "eks-cluster-${local.common_all.eks_cluster_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon-eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_security_group_rule" "ingress_cluster" {
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [local.global.base_vpc.cidr]
}
