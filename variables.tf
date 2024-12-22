

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "eks-demo"
}

variable "eks_version" {
  description = "The version of EKS"
  type        = string
  default     = "1.31"
}

variable "desired_size" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 1
}
variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 1
}
variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_group_name" {
  description = "The name of the node group"
  type        = string
  default     = "node_demo"
}

variable "subnet_ids" {
  description = "The subnet IDs for the EKS node group"
  type        = list(string)
  default     = ["subnet-07397980c132d51e6", "subnet-0c38690de6cd35a27"]
}