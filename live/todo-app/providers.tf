terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    key    = "dev/services/terraform.tfstate"
    region = "us-east-2"
    bucket = "dhan-todos-dev-remote-state"
    # for state locking
    dynamodb_table = "dhan-todos-dev-terraform-state-lock"
    encrypt        = true
    profile        = "cloudtech"
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  profile = "cloudtech"
}
