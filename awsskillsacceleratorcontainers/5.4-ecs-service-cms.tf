/*
    Resource: CloudWatch Log Group
    Description: Create a log group for the container to write to.
 */

resource "aws_cloudwatch_log_group" "cms_service_log_group" {
  name = "/ecs/${local.ecs_service_name_prefix}-cms-ms"
}

/*
    Resource: ECS Task Definition
    Description: Create a blueprint used to provision and run container (tasks)
 */

resource "aws_ecs_task_definition" "cms_service_task_definition" {
  /*
   *    Resources that must exist before creating the task definition
   */
  depends_on = [aws_ecs_cluster.ks_ecs_cluster]

  /*
   *    Tasks definition family for grouping purposes
   */
  family = "${local.ecs_service_name_prefix}-cms-ms"

  /*
   *    Core blueprint for task definiotion
   */
  container_definitions = templatefile("./5.3-td.json.tpl", {
    name                   = "${local.ecs_service_name_prefix}-cms-ms" //car-dealership-plaform-cms-ms
    image                  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.region}.amazonaws.com/${local.project_name}/cms:15fd81f-2025-11-11-12-45"
    essential              = true
    loggroup               = aws_cloudwatch_log_group.cms_service_log_group.name
    aws_region             = data.aws_region.current.region
    readonlyRootFilesystem = true
    mountPoints = [
      {
        sourceVolume  = "strapi-tmp",
        containerPath = "/app/.tmp",
        readOnly      = false
      }
    ]
    portMappings = jsonencode([
      {
        "containerPort" = 1337
        "hostPort"      = 0
      },
    ])
    secrets = jsonencode([
      {
        name      = "DATABASE_USERNAME"
        valueFrom = "${module.ks_database.db_instance_master_user_secret_arn}:username::"
      },
      {
        name      = "DATABASE_PASSWORD"
        valueFrom = "${module.ks_database.db_instance_master_user_secret_arn}:password::"
      },
      {
        name      = "DATABASE_CLIENT"
        valueFrom = "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_parameter_name_prefix}/rds/client"
      },
      {
        name      = "DATABASE_HOST"
        valueFrom = "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_parameter_name_prefix}/rds/host"
      },
      {
        name      = "DATABASE_PORT"
        valueFrom = "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_parameter_name_prefix}/rds/port"
      },
      {
        name      = "DATABASE_NAME"
        valueFrom = "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_parameter_name_prefix}/rds/name"
      },
      {
        name      = "APP_KEYS"
        valueFrom = "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:cmscredentials-VQXftq:APP_KEYS::"
      },
      {
        name      = "API_TOKEN_SALT"
        valueFrom = "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:cmscredentials-VQXftq:API_TOKEN_SALT::"
      },
      {
        name      = "ADMIN_JWT_SECRET"
        valueFrom = "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:cmscredentials-VQXftq:ADMIN_JWT_SECRET::"
      },
      {
        name      = "TRANSFER_TOKEN_SALT"
        valueFrom = "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:cmscredentials-VQXftq:TRANSFER_TOKEN_SALT::"
      },
      {
        name      = "ENCRYPTION_KEY"
        valueFrom = "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:cmscredentials-VQXftq:ENCRYPTION_KEY::"
      },
      {
        name      = "JWT_SECRET"
        valueFrom = "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:cmscredentials-VQXftq:JWT_SECRET::"
      },
      // Todo: Add bucket name for storing cmd media to S3.
      {
        name      = "AWS_BUCKET"
        valueFrom = "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_parameter_name_prefix}/cms/bucket"
      }
    ])

  })

  /*
   *    Required architecture for running each container (task)
   */
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  /*
   *    Launch type required for containers
   */
  requires_compatibilities = ["EC2"]

  /*
   *    Network type required for EC2 based containers (taskss)
   */
  network_mode = "bridge"


  /*
   *    Task roles required Image pulling, aws service access etc.
   */
  execution_role_arn = aws_iam_role.TaskExecutionRoleForECSAgent.arn
  task_role_arn      = aws_iam_role.TaskExecutionRoleForContainer.arn

  /*
   *    Ephemeral volume for .tmp
   */
  volume {
    name = "strapi-tmp"
  }



}

/*
    Resource: ECS Service
    Description: Provisions and orchestrates running containers (tasks)
 */

resource "aws_ecs_service" "cms_service" {
  depends_on = [aws_ecs_cluster.ks_ecs_cluster]

  /*
   *  Cluster to attache service to
   */
  cluster = aws_ecs_cluster.ks_ecs_cluster.name

  /*
   *  Name of the ECS service
   */
  name = "${local.ecs_service_name_prefix}-cms-ms"

  /*
   *  Task definition (blueprint) for creating containers (tasks)
   */
  task_definition = aws_ecs_task_definition.cms_service_task_definition.arn

  /*
   *  Compute type for running the containers
   */
  launch_type = "EC2"

  /*
   *  Number of service instance
   */
  desired_count = 1


  /*
   *  Number of service instance
   */
  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = "${local.ecs_service_name_prefix}-cms-ms"
    container_port   = 1337
  }
}