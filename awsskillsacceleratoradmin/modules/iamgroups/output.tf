output "iam_group_id" {
  value = aws_iam_group.iam_group[*].id
}

output "iam_group_arn" {
  value = aws_iam_group.iam_group[*].arn
}

output "iam_group_name" {
  value = aws_iam_group.iam_group[*].name
}
