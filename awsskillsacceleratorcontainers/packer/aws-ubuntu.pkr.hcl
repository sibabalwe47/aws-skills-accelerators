# aws-ecs-al2-arm64.pkr.hcl
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.6.0"
    }
  }
}

source "amazon-ebs" "al2_ecs_arm" {
  region = "af-south-1"

  # Official ECS-Optimized AL2 (ARM64) base
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-ecs-hvm-*-arm64-ebs"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  instance_type               = "t4g.small"
  ssh_username                = "ec2-user"
  associate_public_ip_address = true

  ami_name        = "awssa-ecs-al2-arm64-{{timestamp}}"
  ami_description = "Custom ECS-Optimized (AL2, ARM64) for af-south-1"

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = "awssa-ecs-al2-arm64"
    Base        = "ecs-optimized-al2-arm64"
    Arch        = "arm64"
    PackerBuild = "{{timestamp}}"
  }
}

build {
  name    = "ecs-optimised-custom-arm64-af-south-1"
  sources = ["source.amazon-ebs.al2_ecs_arm"]

  provisioner "shell" {
    inline = [
      "sudo yum -y update-minimal --security --bugfix || true",
      "sudo yum -y install jq curl unzip amazon-cloudwatch-agent || true",
      "echo 'ECS_ENABLE_TASK_IAM_ROLE=true'               | sudo tee -a /etc/ecs/ecs.config",
      "echo 'ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true' | sudo tee -a /etc/ecs/ecs.config",
      "echo 'ECS_IMAGE_PULL_BEHAVIOR=prefer-cached'      | sudo tee -a /etc/ecs/ecs.config",
      "systemctl list-unit-files | grep -q docker.service && sudo systemctl enable docker || true",
      "systemctl list-unit-files | grep -q ecs.service    && sudo systemctl enable ecs    || true",
      "sudo cloud-init clean --logs || true"
    ]
  }
}
