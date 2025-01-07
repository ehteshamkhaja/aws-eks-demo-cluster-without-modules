resource "aws_eks_addon" "eks-addon" {

  for_each     = toset(["coredns", "vpc-cni", "kube-proxy", "eks-pod-identity-agent"])
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = each.key
}