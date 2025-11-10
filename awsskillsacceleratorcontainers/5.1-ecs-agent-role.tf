/*
    Resource: IAM Role
    Description: Creates a task execution role and the permissions 
    required by the ECS Agent to make calls to various AWS services.
 */

resource "aws_iam_role" "TaskExecutionRoleForECSAgent" {
  name = "${local.project_name}-TaskExecutionRoleForECSAgent"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_policy" "TaskExecutionRoleForECSAgentPolicy" {
  name        = "${local.project_name}-TaskExecutionRoleForECSAgentPolicy"
  description = "IAM policies for the ECS Agent."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ecr:GetAuthorizationToken",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action = [
          "ssm:GetParameters"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter/*"
        ]
      },
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:rds!db-*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "TaskExecutionRoleForECSAgentAttachment" {
  name       = "${local.project_name}-TaskExecutionRoleForECSAgentAttachment"
  roles      = [aws_iam_role.TaskExecutionRoleForECSAgent.name]
  policy_arn = aws_iam_policy.TaskExecutionRoleForECSAgentPolicy.arn
}