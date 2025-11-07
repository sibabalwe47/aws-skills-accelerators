/*
    Resource: AWS Data Sources
    Description: Allow to query resource configuration from AWS (Region, AZs etc)
 */

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "this" {
  state = "available"
}