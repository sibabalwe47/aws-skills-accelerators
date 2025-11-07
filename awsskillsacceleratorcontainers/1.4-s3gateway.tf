resource "aws_vpc_endpoint" "s3_gateway" {
  /*
  * VPC ID will come from the VPC module
  */
  vpc_id = module.vpc.vpc_id

  /*
   * VPC Endpoint type - Gateway (free for S3 and DynamoBD) & Endpoint (p/h)
   */
  vpc_endpoint_type = "Gateway"

  /*
   *  Service endpoint
   */
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  /*
   *  Attach to every private route table
   */
  route_table_ids = module.vpc.private_route_table_ids

  tags = merge(local.default_tags, {
    Name = "${local.project_name}-network-s3-gateway"
  })
}