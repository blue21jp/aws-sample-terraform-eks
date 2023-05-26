# [VPC]
# - EFSファイル システムを使用する予定がある場合は、
#   dns サポートとホスト名を有効にすること。
#   そうしないと、CSI ドライバーは EFS エンドポイントの解決に失敗する。

# [SUBNET]
# - 4つのサブネットを作成する必要がある。
#   2つのprivateサブネットと2 つのpublicサブネット。
# - ALBに自動的にサブネットを認識させるために、
#   private用のinternal-elbタグと、public用のelbタグを設定する。
#   ALB作成時にサブネットを指定することも可能だが
#   今回は、自動認識を試す。
# - 所有値または共有値を持つclusterタグを設定する。

resource "aws_ec2_tag" "public_subnet_tag1" {
  count = length(data.aws_subnet.public)

  resource_id = data.aws_subnet.public[count.index].id
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "public_subnet_tag2" {
  count = length(data.aws_subnet.public)

  resource_id = data.aws_subnet.public[count.index].id
  key         = "kubernetes.io/cluster/${local.common_all.eks_cluster_name}"
  value       = "owned"
}

resource "aws_ec2_tag" "private_subnet_tag1" {
  count = length(data.aws_subnet.private)

  resource_id = data.aws_subnet.private[count.index].id
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_tag2" {
  count = length(data.aws_subnet.private)

  resource_id = data.aws_subnet.private[count.index].id
  key         = "kubernetes.io/cluster/${local.common_all.eks_cluster_name}"
  value       = "owned"
}
