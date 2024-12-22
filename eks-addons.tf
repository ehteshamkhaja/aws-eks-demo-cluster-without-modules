
resource "aws_eks_addon" "addon" {
  cluster_name = aws_eks_cluster.aws_eks.name
  for_each     = toset(["vpc-cni", "kube-proxy", "coredns", "eks-pod-identity-agent"])
  addon_name   = each.key
  depends_on   = [aws_eks_node_group.node]
}
