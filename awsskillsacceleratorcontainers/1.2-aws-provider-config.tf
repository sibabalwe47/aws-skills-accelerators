/*
    Resource: Provider Configuration
    Description: Configures the region and default tags used when provisioning resources. 
    Access to AWS will be configured using the AWS_PROFILE environment variable.
 */
provider "aws" {
  region = var.aws_skills_accelerator_region

  default_tags {
    tags = local.default_tags
  }
}
