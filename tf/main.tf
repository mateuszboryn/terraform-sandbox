terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.53.0"
    }
  }
  required_version = ">= 1.0.4"

  backend "s3" {
    bucket = "tf-541147820420-eu-west-1"
    key = "tf/dev/tf-sandbox.tfstate"
    region = "eu-west-1"
    profile = "amplify"
  }
}

provider "aws" {
  profile = "amplify"
  region = "eu-west-1"
  default_tags {
    tags = {
      app = var.app_long
      env = var.env
    }
  }
}