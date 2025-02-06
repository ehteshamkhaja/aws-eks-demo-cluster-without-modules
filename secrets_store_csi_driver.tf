#helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
#helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system
# syncSecret.enabled=true

resource "helm_release" "secrets_store_csi_driver" {
  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  version    = "1.3.2" # Use a specific version

  namespace = "kube-system"

  set {
    name  = "enableSecretRotation" # Enable secret rotation (optional but recommended)
    value = "true"
  }
  set {
    name  = "syncSecret.enabled" # Sync Kubernetes secrets with AWS Secrets Manager
    value = "true"
  }
}
# helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
# helm install -n kube-system csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver

# Install the AWS Secrets Manager provider
resource "helm_release" "secrets_store_csi_driver_provider_aws" {
  name       = "aws-secrets-manager"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-provider-aws"
  version    = "1.0.1" # Use a specific version
  depends_on = [helm_release.secrets_store_csi_driver] # Ensure the CSI driver is installed first
}

output "secrets_store_csi_driver_version" {
  value = helm_release.secrets_store_csi_driver.version
}

output "secrets_store_csi_driver_provider_aws_version" {
  value = helm_release.secrets_store_csi_driver_provider_aws.version
}


