# Namespace
resource "kubernetes_namespace" "my-namespace" {
  metadata {
    name = "my-namespace"
  }
}

# Trusted entities
data "aws_iam_policy_document" "secrets_csi_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.cluster.url}:sub"
      values   = ["system:serviceaccount:${kubernetes_namespace.my-namespace.metadata[0].name}:${aws_iam_policy.secrets_csi.name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.cluster.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = "${aws_iam_openid_connect_provider.cluster.arn}"
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "secrets_csi" {
  assume_role_policy = data.aws_iam_policy_document.secrets_csi_assume_role_policy.json
  name               = "secrets-csi-role"
}

# Policy
resource "aws_iam_policy" "secrets_csi" {
  name = "secrets-csi-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = ["${data.aws_secretsmanager_secret.secrets_csi.arn}"]
    }]
  })
}

data "aws_secretsmanager_secret" "secrets_csi" {
  name = "<SECRET-NAME>"
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.secrets_csi.name
}

# Service Account
resource "kubectl_manifest" "secrets_csi_sa" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
  namespace: my-namespace
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.secrets_csi.arn}
YAML

  depends_on = [kubernetes_namespace.my-namespace]
}