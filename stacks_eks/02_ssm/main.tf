locals {
  ssh_private_key = file(local.common_all.git_info.ssh_private_key)
}

resource "aws_ssm_parameter" "git_ssh_private_key" {
  name  = local.common_all.git_info.ssm_ssh_private_key
  type  = "SecureString"
  value = base64encode(local.ssh_private_key)
}
