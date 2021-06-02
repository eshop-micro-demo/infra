terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.43.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.1.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.2.0"
    }
  }
}
