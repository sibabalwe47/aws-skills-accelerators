resource "aws_iam_group_policy" "iam_group_policies" {
  name  = "${var.iam_group_name}AccessPolicies"
  group = var.iam_group_name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = var.iam_group_policies
  })
}
