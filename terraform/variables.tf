# Provider specific settings

variable "aws_region" {
  default     = "ap-south-1"
  description = "AWS region to speak to"
}

variable "kube2iam_demo_s3_bucket" {
  default = "vj-kube2iam-demo"
  description = "Name of the bucket to demo kube2iam. Purposefully not managed via terraform"
}
