/*
    Resource: CloudWatch Log Group
    Description: Create a log group for the container to write to.
 */

resource "aws_cloudwatch_log_group" "authentication_service_log_group" {
  name = "/ecs/${local.ecs_service_name_prefix}-authentication-ms"
}

/*
    Resource: ECS Task Definition
    Description: Create a blueprint used to provision and run container (tasks)
 */

resource "aws_ecs_task_definition" "authentication_service_task_definition" {
  /*
   *    Resources that must exist before creating the task definition
   */
  depends_on = [aws_ecs_cluster.ks_ecs_cluster]

  /*
   *    Tasks definition family for grouping purposes
   */
  family = "${local.ecs_service_name_prefix}-authentication-ms"

  /*
   *    Core blueprint for task definiotion
   */
  container_definitions = templatefile("./5.3-td.json.tpl", {
    name       = "${local.ecs_service_name_prefix}-authentication-ms"
    image      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.region}.amazonaws.com/${local.project_name}/backend-aggregator:0e08ac5-2025-11-08-06-16"
    essential  = true
    loggroup   = aws_cloudwatch_log_group.authentication_service_log_group.name
    aws_region = data.aws_region.current.region
    portMappings = jsonencode([
      {
        "containerPort" = 4000
        "hostPort"      = 0
      },
    ])
    secrets = jsonencode([

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

}

/*
    Resource: ECS Service
    Description: Provisions and orchestrates running containers (tasks)
 */

resource "aws_ecs_service" "authentication_service" {
  depends_on      = [aws_ecs_cluster.ks_ecs_cluster]
  cluster         = aws_ecs_cluster.ks_ecs_cluster.name
  name            = "${local.ecs_service_name_prefix}-authentication-ms"
  task_definition = aws_ecs_task_definition.authentication_service_task_definition.arn
  launch_type     = "EC2"
  desired_count   = 1

  #   network_configuration {
  #     subnets          = module.vpc.private_subnets
  #     assign_public_ip = false
  #     //security_groups  = [aws_security_group.fargate_security_group.id]
  #   }

  # load_balancer {
  #   target_group_arn = module.alb_external.target_group_arns[0]
  #   container_name   = "authentication"
  #   container_port   = 4000
  # }
}