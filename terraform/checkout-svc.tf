# Maria-DB- Checkout microservice
resource "helm_release" "checkout-db" {
  name       = "checkout-db"
  chart      = "mariadb"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "9.3.13"
  namespace  = "microshop"
  create_namespace = true
  atomic = true

  values = [
    "${file("helm/values.checkout-db.yaml")}"
  ]
}

