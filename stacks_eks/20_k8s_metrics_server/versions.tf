terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.34.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.4"
    }
  }
  required_version = ">= 1.3.6"
}
