provider "helm" {
}
provider "kubernetes" {
}

# EFS nfs-provisioner
resource "helm_release" "nfs-subdir-external-provisioner" {
  depends_on = [
    aws_efs_mount_target.efs-volume-targets
  ]
  name       = "nfs-subdir-external-provisioner"
  chart      = "nfs-subdir-external-provisioner"
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  version    = "4.0.10"
  namespace  = "storage"
  create_namespace = true
  atomic = true

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

# nginx-ingress-controller
resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "3.31.0"
  namespace  = "ingress-nginx"
  create_namespace = true
  atomic = true
}

# kube2iam
resource "helm_release" "kube2iam" {
  name       = "kube2iam"
  chart      = "kube2iam"
  repository = "https://jtblin.github.io/kube2iam/"
  version    = "2.6.0"
  namespace  = "kube2iam"
  create_namespace = true
  atomic = true
  
  values = [
    "${file("helm/values.kube2iam.yaml")}"
  ]
}


# Cert-manager
resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io/"
  version    = "1.3.1"
  namespace  = "cert-manager"
  create_namespace = true
  atomic = true
}

# External-DNS
resource "helm_release" "external-dns" {
  name       = "external-dns"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "5.0.2"
  namespace  = "external-dns"
  create_namespace = true
  atomic = true

  values = [
    "${file("helm/values.external-dns.yaml")}"
  ]
  set {
    name  = "podAnnotations.iam\\.amazonaws\\.com/role"
    value = aws_iam_role.external-dns-role.arn
  }
}
