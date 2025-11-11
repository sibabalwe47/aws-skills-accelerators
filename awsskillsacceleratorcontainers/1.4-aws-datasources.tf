/*
    Resource: AWS Data Sources
    Description: Allow to query resource configuration from AWS (Region, AZs etc)
 */

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_partition" "current" {}

data "aws_ssm_parameter" "ecs_ami_al2_x86" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

