/*
    Resource: Terraform Backend
    Description: Configure Terraform to make use of S3 to store state files.
 */
terraform {
  backend "s3" {
    bucket       = "kloudspaceplatformbubcketstate"
    key          = "awsskillsacceleratorcontainers/state"
    region       = "af-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
