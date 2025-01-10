/*
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "my-terraform-infra-bucket"
    key    = "terraform.tfstate"
    region = var.region
  }
  
}

output "terraform_remote_state_name" {

  value = data.terraform_remote_state.eks.outputs
}
*/