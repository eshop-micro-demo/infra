provider "helm" {
}
# provider "kubernetes" {
# }

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
  # extra time for EFS DNS names to become available
  timeout = 600

  set {
    name  = "nfs.server"
    value = aws_efs_file_system.efs-volume.dns_name
  }
  values = [
    "${file("helm/values.nfs-provisioner.yaml")}"
  ]
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
  values = [
    "${file("helm/values.nginx-ingress.yaml")}"
  ]

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
  values = [
    "${file("helm/values.cert-manager.yaml")}"
  ]
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

# Kube-Prometheus-stack
resource "helm_release" "prometheus-stack" {
  name       = "kube-prometheus-stack"
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "16.10.0"
  namespace  = "monitoring"
  create_namespace = true
  atomic = true

  values = [
    "${file("helm/values.prometheus-stack.yaml")}"
  ]
}

# Staketer-reloader
resource "helm_release" "stakater" {
  name       = "stakater"
  chart      = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  version    = "v0.0.95"
  atomic = true
  set {
    name  = "reloader.podMonitor.enabled"
    value = "true"
  }
}