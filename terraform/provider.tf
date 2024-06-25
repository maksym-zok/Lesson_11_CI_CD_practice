terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.45.0"
    }
  }

  backend "s3" {
    bucket         = "tfstate-sid24-xyz"
    key            = "maksym-hlyva"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-lock"
  }
}