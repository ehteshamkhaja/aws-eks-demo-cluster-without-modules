resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = kubernetes_namespace.external_secrets.metadata[0].name
  version    = "0.8.1" # Specify the version you want to install

  set {
    name  = "installCRDs"
    value = "true" # Important: ensure CRDs are installed
  }
  depends_on = [
    kubernetes_namespace.external_secrets
  ]
}