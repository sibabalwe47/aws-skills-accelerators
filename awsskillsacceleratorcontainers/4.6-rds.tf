/*
    Resource: RDS Database
    Description: Creates a task execution role and the permissions 
    required by the ECS Agent to make calls to various AWS services.
 */
module "ks_database" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.13.1"

  /*
   * Name of the database resource
   */
  identifier = "${local.project_name}-db"

  /*
   * Engine settings
   */
  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14"
  major_engine_version = "14"
  instance_class       = "db.t4g.micro"

  /*
   * Storage
   */
  allocated_storage = 20

  /*
   * Access credentials
   */
  db_name                     = "cdpdatabase"
  username                    = "cdpdatabaseadmin"
  manage_master_user_password = true
  port                        = 5432

  /*
   * Databae network placement
   */
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [aws_security_group.rds_db_security_group.id]


  /*
   * Maintenance configuration
   */
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0
}

/*
  Resource: SSM Parameters
  Description: Stores DB related credentials and information for 
  CMS, CRM, or Markting tools
 */

resource "aws_ssm_parameter" "rds_database_client" {
  depends_on = [module.ks_database]
  name       = "${local.ssm_parameter_name_prefix}/rds/client"
  type       = "String"
  value      = module.ks_database.db_instance_engine
}

resource "aws_ssm_parameter" "rds_database_host" {
  depends_on = [module.ks_database]
  name       = "${local.ssm_parameter_name_prefix}/rds/host"
  type       = "String"
  value      = module.ks_database.db_instance_address
}

resource "aws_ssm_parameter" "rds_database_port" {
  depends_on = [module.ks_database]
  name       = "${local.ssm_parameter_name_prefix}/rds/port"
  type       = "String"
  value      = module.ks_database.db_instance_port
}

resource "aws_ssm_parameter" "rds_database_name" {
  depends_on = [module.ks_database]
  name       = "${local.ssm_parameter_name_prefix}/rds/name"
  type       = "String"
  value      = module.ks_database.db_instance_name
}

