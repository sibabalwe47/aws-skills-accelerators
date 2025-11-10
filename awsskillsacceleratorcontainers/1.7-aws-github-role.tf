resource "aws_iam_openid_connect_provider" "github_oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  url             = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "GitHubActionsCICDAssumeRole" {
  name = "GitHubActionsCICDAssumeRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.github_oidc_provider.arn}"
        }
        Condition = {
          StringEquals = {
            "${element(split("oidc-provider/", "${aws_iam_openid_connect_provider.github_oidc_provider.arn}"), 1)}:aud" : "sts.amazonaws.com",
            "${element(split("oidc-provider/", "${aws_iam_openid_connect_provider.github_oidc_provider.arn}"), 1)}:sub" : [
              "repo:sibabalwe47/aws-ecs-masterclass-authentication-ms:ref:refs/heads/main",
              "repo:sibabalwe47/car-dealership-platform-cms-ms:ref:refs/heads/main"

            ]
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "GitHubActionsCICDAssumeRolePolicies" {
  name        = "GitHubActionsCICDAssumeRolePolicies"
  description = "Policy for the app"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:*",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}


resource "aws_iam_policy_attachment" "GitHubActionsCICDAssumeRoleAttachment" {
  name       = "GitHubActionsCICDAssumeRoleAttachment"
  roles      = [aws_iam_role.GitHubActionsCICDAssumeRole.name]
  policy_arn = aws_iam_policy.GitHubActionsCICDAssumeRolePolicies.arn
}