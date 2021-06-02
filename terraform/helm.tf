# provider "helm" {
# }
# provider "kubernetes" {
# }

# resource "kubernetes_namespace" "storage" {
#   metadata {
#     name = "storage"
#   }
# }

# resource "helm_release" "nfs-subdir-external-provisioner" {
#   depends_on = [
#     aws_efs_mount_target.eks-volume-targets
#   ]
#   name       = "nfs-subdir-external-provisioner"
#   chart      = "nfs-subdir-external-provisioner"
#   repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
#   version    = "4.0.10"
#   namespace  = kubernetes_namespace.storage.metadata.0.name

#   set {
#     name  = "nfs.server"
#     value = aws_efs_file_system.eks-volume.dns_name
#   }

#   set {
#     name  = "nfs.path"
#     value = "/"
#   }

#   set {
#     name  = "storageClass.name"
#     value = "efs-client"
#   }
# }