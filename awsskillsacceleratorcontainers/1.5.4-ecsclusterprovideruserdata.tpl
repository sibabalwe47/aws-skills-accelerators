#!/bin/bash

# update packages
sudo yum update -y

# Upgrade all available packages
sudo yum install -y wget

# SSM
sudo yum install -y amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# ECS
sudo yum update -y ecs-init

# Docker
sudo service docker restart

# ECS agenet configuration
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=${ECS_CLUSTER_NAME}
ECS_LOGLEVEL=debug
ECS_CONTAINER_INSTANCE_TAGS=${jsonencode(TAGS)}
ECS_ENABLE_TASK_IAM_ROLE=true
EOF

# Enable ECS
sudo systemctl enable ecs
