resource "aws_ecs_cluster" "ks_ecs_cluster" {
  /*
   *  Cluster name
   */
  name = "${local.project_name}-cluster"

  /*
   *  Cluster configuration
   */
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = "/ecs/${local.project_name}-cluster"
      }
    }
  }

  /*
   *  Cluster configuration
   */
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}