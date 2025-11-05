/*
 * IAM Groups
 */

module "aws_skills_accelerator_global_groups" {
  source          = "./modules/iamgroups"
  iam_group_names = var.aws_skills_accelerator_groups
}
