module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"

  /* 
   * Name of the virtual private network
   */
  name = "${local.project_name}-network"

  /*
   * Clasless Inter-Domain Routing (4091 IPs)
   */
  cidr = local.vpc_cidr

  /*
   * Availability zones
   */
  azs = ["${local.region}a", "${local.region}b", "${local.region}c"]

  /*
   * Public subnets
   */
  public_subnets = local.public_subnets
  public_subnet_names = ["${local.project_name}-public-1a", "${local.project_name}-public-1b", "${local.project_name}-public-1c"
  ]

  /*
   * Private subnets
   */
  private_subnets      = local.cluster_subnets
  private_subnet_names = ["${local.project_name}-cluster-1a", "${local.project_name}-cluster-1b", "${local.project_name}-cluster-1c"]

  /*
   * Private subnets
   */
  database_subnets      = local.database_subnets
  database_subnet_names = ["${local.project_name}-db-1a", "${local.project_name}-db-1b", "${local.project_name}-db-1c"]


  /*
   *  NAT Gateway configuration
   */
  enable_nat_gateway               = true
  single_nat_gateway               = true
  one_nat_gateway_per_az           = false
  default_vpc_enable_dns_hostnames = true
  default_vpc_enable_dns_support   = true
  map_public_ip_on_launch          = true

  /*
   *  NAT Gateway configuration
   */
  tags = merge({}, local.default_tags)

}