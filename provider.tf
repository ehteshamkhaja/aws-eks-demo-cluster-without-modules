terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
  }
  backend "s3" {
    bucket         = "my-terraform-infra-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-infra-table"
  }

}

provider "aws" {
  # Configuration options
  region = var.region
}