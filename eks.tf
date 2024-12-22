
terraform {
  required_providers { // Cloud API provider 
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}


// Create an EKS cluster
resource "aws_eks_cluster" "aws_eks" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  version  = var.eks_version // EKS version

  // Configure VPC for the EKS cluster
  vpc_config {
    subnet_ids = var.subnet_ids // provide minimum two subnet ids for eks cluster creation
  }

  // Add tags to the EKS cluster for identification
  tags = {
    Name = "EKS_demo"
  }
}



// Create an EKS node group
resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  // Configure scaling options for the node group
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  // Ensure that the creation of the node group depends on the IAM role policies being attached
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

