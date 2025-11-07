/*
    Resource: Terraform Plugins
    Description: A configuration of the required aws plugins to provision 
    infrastructure on AWS including version locking.
 */

terraform {
  required_version = ">= 1.11.4, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.8"
    }
  }
}


