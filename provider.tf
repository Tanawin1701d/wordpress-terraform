terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#STEP Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = "god"
}