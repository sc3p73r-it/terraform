terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.68.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
  default_tags {
    tags = {
      "Managed_by" = "Terraform"
    }
  }
}