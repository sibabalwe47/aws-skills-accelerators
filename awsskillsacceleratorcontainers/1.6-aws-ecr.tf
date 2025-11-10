/*
    Resource: ECR Repositories
    Description: Creates the ECR repositories we require for our microservices. These
    will be pulled at runtime by each ECS service via the ECS agent.
 */

module "this" {
  count                             = length(local.car_platform_ecr_repositories)
  source                            = "terraform-aws-modules/ecr/aws"
  repository_name                   = "${local.project_name}/${local.car_platform_ecr_repositories[count.index]}"
  repository_read_write_access_arns = ["*"] // This will change later when we work on ECS cluster
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}


