resource "aws_iam_group" "iam_group" {
  count = length(var.iam_group_names)
  name  = var.iam_group_names[count.index]
  path  = "/"
}
