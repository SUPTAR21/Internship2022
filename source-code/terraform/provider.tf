provider "aws" {
  profile = "supphakit"
  region  = "ap-southeast-1"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
  backend "s3" {
    bucket = "bucketbkk"
    key    = "./terraform.tfstate"
    region = "ap-southeast-1"
    # Enable State Locking
    # dynamodb_table = "nopnithi-terraform-state-demo"
    profile = "supphakit"
  }
}
