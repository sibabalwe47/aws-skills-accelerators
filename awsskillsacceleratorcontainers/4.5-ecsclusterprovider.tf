resource "aws_ecs_capacity_provider" "ks_capacity_provider" {
  name = "${local.project_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.ks_autoscaling_group.autoscaling_group_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 80
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 5
      instance_warmup_period    = 120
    }
  }
}


resource "aws_ecs_cluster_capacity_providers" "ks_capacity_providers" {
  cluster_name       = aws_ecs_cluster.ks_ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ks_capacity_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ks_capacity_provider.name
    base              = 0
    weight            = 1
  }

}