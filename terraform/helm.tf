provider "helm" {
}
provider "kubernetes" {
}

# EFS nfs-provisioner
resource "kubernetes_namespace" "storage" {
  metadata {
    name = "storage"
  }
}

resource "helm_release" "nfs-subdir-external-provisioner" {
  depends_on = [
    aws_efs_mount_target.efs-volume-targets
  ]
  name       = "nfs-subdir-external-provisioner"
  chart      = "nfs-subdir-external-provisioner"
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  version    = "4.0.10"
  namespace  = kubernetes_namespace.storage.metadata.0.name

  set {
    name  = "nfs.server"
    value = aws_efs_file_system.efs-volume.dns_name
  }

  set {
    name  = "nfs.path"
    value = "/"
  }

  set {
    name  = "storageClass.name"
    value = "efs-client"
  }
}

# Cert-manager
resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io/"
  version    = "1.3.1"
  namespace  = kubernetes_namespace.cert-manager.metadata.0.name
}