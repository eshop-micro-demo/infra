resource "aws_efs_file_system" "eks-volume" {
   creation_token = "eks-volumes"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
   tags = {
     Name = "EKSVolumes"
   }
}

resource "aws_efs_mount_target" "eks-volume-targets" {
    for_each      = data.aws_subnet_ids.kops_subnets.ids
  file_system_id = aws_efs_file_system.eks-volume.id
  subnet_id     = each.value

  security_groups = [
    aws_security_group.efs-target-eks-volumes.id
  ]
}

# resource "aws_efs_mount_target" "eks-volumes-ca-central-1b" {
#   file_system_id = aws_efs_file_system.eks-volumes.id
#   subnet_id      = data.aws_subnet_ids.kops_subnets.0

#   security_groups = [
#     aws_security_group.efs-target-eks-volumes.id
#   ]
# }

resource "aws_security_group" "efs-target-eks-volumes" {
  name        = "efs-target-eks-volumes"
  description = "Allows NFS traffic from instances within the VPC."
  vpc_id      = data.aws_vpc.kops_vpc.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    security_groups = [ data.aws_security_group.kops_node_secgrp.id ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    security_groups = [ data.aws_security_group.kops_node_secgrp.id ]
  }
}
