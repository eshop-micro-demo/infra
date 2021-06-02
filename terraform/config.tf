provider "aws" {
  region = var.aws_region
}
terraform {
    backend "s3" {
        bucket = "vj-terraform-store"
        key    = "microshop/aws-tf-store.json"
        region = "ap-south-1"
    }
}