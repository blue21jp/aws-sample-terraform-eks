data "aws_vpc" "main" {
  tags = {
    Name = "${local.global.base_vpc.prefix}-main"
  }
}
data "aws_subnet" "public" {
  count  = 2
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "${local.global.base_vpc.prefix}-public-${data.aws_availability_zone.az[count.index].name_suffix}"
  }
}
data "aws_subnet" "private" {
  count  = 2
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "${local.global.base_vpc.prefix}-private-${data.aws_availability_zone.az[count.index].name_suffix}"
  }
}

data "aws_eks_cluster" "main" {
  name = local.common_all.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = data.aws_eks_cluster.main.id
}

data "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.main.identity[0].oidc[0].issuer
}
