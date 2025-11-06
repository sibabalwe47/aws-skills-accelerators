variable "aws_accelerator_users" {
  default = [
    "siba"
  ]
}

variable "aws_skills_accelerator_region" {
  description = "This is the AWS region that these resources will be deployed into."
  default     = "af-south-1"
}


variable "aws_skills_accelerator_group_name" {
  default = "AWSSkillsAcceleratorContainersCohort"
}