/*
 *  IAM Users for the accelerator
 */
module "AWSSkillsAcceleratorContainersCohortUsers" {
  count                = length(var.aws_accelerator_users)
  source               = "../awsskillsacceleratoradmin/modules/iamusers"
  iam_user_name        = var.aws_accelerator_users[count.index]
  iam_user_group_names = [var.aws_skills_accelerator_group_name]
}