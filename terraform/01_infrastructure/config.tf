terraform {
  required_version = "~>1.3.8"

  backend "s3" {
    workspace_key_prefix = "01_infrastructure"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.23.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "local" {
}
