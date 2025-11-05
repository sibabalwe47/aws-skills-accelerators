/*
 * IAM Policies
 */

module "AWSSkillsAcceleratorContainersCohortPolicies" {
  source         = "../awsskillsacceleratoradmin/modules/iamgrouppolicies"
  iam_group_name = var.aws_skills_accelerator_group_name
  iam_group_policies = [
    {
      Sid    = "DenyUserListingAllUsers"
      Effect = "Deny"
      Action = [
        "iam:ListUsers"
      ]
      Resource = "*"
    },
    {
      Sid    = "AllowUserToGetOwnUser"
      Effect = "Allow"
      Action = [
        "iam:GetUser",
        "iam:GetLoginProfile",
        "iam:ListAccessKeys",
        "iam:ListMFADevices",
        "iam:ListSSHPublicKeys",
        "iam:ListServiceSpecificCredentials",
        "iam:ListUserPolicies",
        "iam:GetUserPolicy",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListSigningCertificates"
      ]
      Resource = "arn:aws:iam::*:user/$${aws:username}"
    },
    {
      Sid    = "AllowManageOwnAccessKeys"
      Effect = "Allow"
      Action = [
        "iam:CreateAccessKey",
        "iam:UpdateAccessKey",
        "iam:DeleteAccessKey",
        "iam:ListAccessKeys"
      ]
      Resource = "arn:aws:iam::*:user/$${aws:username}"
    },
    {
      Sid      = "AllowViewOwnAccessKeyUsage"
      Effect   = "Allow"
      Action   = "iam:GetAccessKeyLastUsed"
      Resource = "*"
    },
    {
      Sid    = "AllowVpcAccessOperations"
      Effect = "Allow"
      Action = [
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeNatGateways",
        "ec2:DescribeNetworkAcls",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeEgressOnlyInternetGateways",
        "ec2:DescribeVpcEndpoints",
        "route53resolver:ListFirewallRuleGroupAssociations",
        "ec2:CreateTags"
      ]
      Resource = "*"
      Condition = {
        StringEquals = {
          "aws:RequestedRegion" = var.aws_skills_accelerator_regions
        }
      }
    },
    {
      Sid    = "AllowVpcCreate"
      Effect = "Allow"
      Action = [
        "ec2:CreateVpc"
      ]
      Resource = "*"
      Condition = {
        StringEquals = {
          "aws:RequestedRegion" = var.aws_skills_accelerator_regions
        }
      }
    }
  ]
}
