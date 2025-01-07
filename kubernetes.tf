
provider "kubernetes" {
  config_path = "~/.kube/config"
}


resource "kubernetes_cluster_role_v1" "eks-cluster-role" {
  metadata {
    name = "my-eks-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "some_role_binding" {
  metadata {
    name = "eks-role-name-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.eks-cluster-role.metadata[0].name
  }

  subject {
    kind = "User"
    name = "devops" # or whatever the user name is
  }
}
