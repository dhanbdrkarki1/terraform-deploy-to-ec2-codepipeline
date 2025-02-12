terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "cloudtech"
  default_tags {
    tags = {
      OwnedBy    = "Dhan"
      Department = "DevOps"
      ManagedBy  = "Terraform"
    }
  }
}
