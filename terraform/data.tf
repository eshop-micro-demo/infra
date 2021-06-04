data "aws_vpc" "kops_vpc" {
    tags = {
      "Name" = "kopsdemo.k8s.local"
    }
}

data "aws_subnet_ids" "kops_subnets" {
  vpc_id = data.aws_vpc.kops_vpc.id
  tags = {
    "KubernetesCluster" = "kopsdemo.k8s.local"
  }
}

data "aws_security_group" "kops_node_secgrp" {
  tags = {
    "Name" = "nodes.kopsdemo.k8s.local"
  }
}

data "aws_route53_zone" "main-zone" {
  name         = "dh4r4pvj.ga."
  private_zone = false
}

data "aws_iam_role" "kops_nodes_role" {
  name = "nodes.kopsdemo.k8s.local"
}