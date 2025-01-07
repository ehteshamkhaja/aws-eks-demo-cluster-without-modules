/*
data "aws_iam_user" "example" {
  user_name = "devops"
}

resource "aws_eks_access_entry" "example" {
  cluster_name  = var.cluster_name
  principal_arn = data.aws_iam_user.example.arn
  # kubernetes_groups = ["group-1", "group-2"]
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks-cluster-admin-policy-1" {
  cluster_name  = var.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = data.aws_iam_user.example.arn

  access_scope {
    type = "cluster"
    # namespaces = ["example-namespace"]
  }
  depends_on = [aws_eks_access_entry.example]
}

resource "aws_eks_access_policy_association" "eks-cluster-admin-policy-2" {
  cluster_name  = var.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_iam_user.example.arn

  access_scope {
    type = "cluster"
    # namespaces = ["example-namespace"]
  }
  depends_on = [aws_eks_access_entry.example]
}

output "user_arn" {
  value = data.aws_iam_user.example.arn
}
*/