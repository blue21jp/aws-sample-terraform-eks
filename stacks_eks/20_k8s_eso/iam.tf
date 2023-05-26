data "aws_iam_policy_document" "eso_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:external-secrets:external-secrets"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eso" {
  name               = "${local.common_all.project}-eso-role"
  assume_role_policy = data.aws_iam_policy_document.eso_assume_role_policy.json
}

resource "aws_iam_policy" "eso" {
  policy = file("external_secrets_policy.json")
  name   = "${local.common_all.project}-eso-policy"
}

resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso.id
  policy_arn = aws_iam_policy.eso.arn
}
