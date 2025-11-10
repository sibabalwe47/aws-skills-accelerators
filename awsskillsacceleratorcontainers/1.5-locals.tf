/*
    Resource: Project Variables
    Description: Global variables, naming conventions, and settings used
    throughout the project
 */


locals {
  /*
   *  AWS Selected region
   */
  region = var.aws_skills_accelerator_region

  /*
   *  AWS Skills accelerator conventions
   */
  cohort_type  = "asac"
  cohort       = "ch01"
  project_name = "${local.default_tags.OwnedBy}-car-platform"

  /*
   * AMI ID for the cluster capacity provider
   */
  ecs_ami_al2_x86 = jsondecode(data.aws_ssm_parameter.ecs_ami_al2_x86.value).image_id

  /*
   *  VPC CIDR
   */
  vpc_cidr = "10.0.0.0/20"

  /*
   *  Availability zones (Pick 3 AZs in given region and sort alphabetically)
   */
  azs = slice(sort(data.aws_availability_zones.this.names), 0, 3)

  /*
      Create one /24 per AZ in region: add 2 bits -> /24
   */
  az_blocks = [for k, _ in local.azs : cidrsubnet(local.vpc_cidr, 2, k)]

  /*
      Inside each /24, place subnets on clean boundaries

      (i)   Public subnets - NAT Gateway
      (ii)  Cluster container subnets (private) - Microservice, VPC endpoints
      (iii) Databases subnets (private) - RDS, Elasticache
   */

  cluster_subnets  = [for b in local.az_blocks : cidrsubnet(b, 1, 0)]
  database_subnets = [for b in local.az_blocks : cidrsubnet(b, 2, 2)]
  public_subnets   = [for b in local.az_blocks : cidrsubnet(b, 3, 6)]


  /*
   * (optional) spare per AZ if you ever needed:
   */
  spare_per_az = [for b in local.az_blocks : cidrsubnet(b, 3, 7)] # /27 at .224

  /*
   * (optional) whole VPC spare /24 (the 4th /24 inside the /22)
   */
  spare_vpc_block = cidrsubnet(local.vpc_cidr, 2, 3)

  /*
   * ECR Private repository names
   */
  car_platform_ecr_repositories = [
    "crm",
    "website",
    "marketing-automation",
    "backend-aggregator",
    "cms"
  ]

  /*
   * ECS service naming convention
   */
  ecs_service_name_prefix = "car-dealership-platform"

  /*
   * SSM Parameter store naming convention
   */
  ssm_parameter_name_prefix = "/car-dealership-platform/sn"

  default_tags = {
    Project   = "AWSSkillsAcceleratorContainersOperations"
    ManagedBy = "sibabalwe47@gmail.com"
    OwnedBy   = "siba"
  }
}
