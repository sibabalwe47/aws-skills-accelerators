variable "aws_skills_accelerator_region" {
  description = "This is the AWS region that these resources will be deployed into."
  default     = "af-south-1"
}

variable "aws_skills_accelerator_regions" {
  default = ["us-east-1", "us-east-2", "us-west-2", "af-south-1"]
}

variable "aws_skills_accelerator_groups" {
  default = [
    "AWSSkillsAcceleratorContainersCohort",
    "AWSSkillsAcceleratorServerlessCohort",
    "AWSSkillsAcceleratorAIAgentsCohort"
  ]
}

variable "aws_skills_accelerator_group_name" {
  default = "AWSSkillsAcceleratorContainersCohort"
}