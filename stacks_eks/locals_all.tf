locals {
  common_all = {
    project = "eks"
    author  = local.global.unit

    eks_cluster_name = "eks-main"

    git_info = {
      ssh_private_key     = "~/.ssh/id_rsa"
      ssm_ssh_private_key = "/bitbucket/ssh_private_key"
    }

    app1 = {
      repo_name   = "sandbox"
      repository  = "git@bitbucket.org:blue21/tf-sample-eks.git"
      rev         = "HEAD"
      app_name    = "nginx"
      app_path    = "app/nginx"
      app_project = "default"
    }
    app2 = {
      repo_name   = "sandbox"
      repository  = "git@bitbucket.org:blue21/tf-sample-eks.git"
      rev         = "HEAD"
      app_name    = "php-apache"
      app_path    = "app/php"
      app_project = "default"
    }
  }
}

data "aws_availability_zones" "az_names" {}
data "aws_availability_zone" "az" {
  count = length(data.aws_availability_zones.az_names.names)
  name  = data.aws_availability_zones.az_names.names[count.index]
}
