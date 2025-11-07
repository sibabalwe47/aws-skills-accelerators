/*
    Resource: IAM Role
    Description: Creates a task execution role and the permissions 
    required by the ECS Agent to make calls to various AWS services.
 */

resource "aws_iam_role" "TaskExecutionRoleForContainer" {
  name = "${local.project_name}-TaskExecutionRoleForContainer"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_policy" "TaskExecutionRoleForContainerPolicy" {
  name        = "${local.project_name}-TaskExecutionRoleForContainerPolicy"
  description = "IAM policies for the ECS Agent."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ],
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "TaskExecutionRoleForContainerPolicyAttachment" {
  name       = "${local.project_name}-TaskExecutionRoleForContainerPolicyAttachment"
  roles      = [aws_iam_role.TaskExecutionRoleForContainer.name]
  policy_arn = aws_iam_policy.TaskExecutionRoleForContainerPolicy.arn
}