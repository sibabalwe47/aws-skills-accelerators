terraform {
  required_version = ">= 1.11.4, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.8"
    }
  }
}


provider "aws" {
  region = var.aws_skills_accelerator_region

  default_tags {
    tags = local.default_tags
  }
}
