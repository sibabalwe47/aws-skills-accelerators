resource "aws_security_group" "security_group" {
  name        = "${local.project_name}-asg-sg"
  description = "EC2 security group for Autoscaling group instances."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "HTTPS ingress traffic from ALB."
    security_groups = [module.alb.security_group_id]
    from_port       = 32768
    to_port         = 65535
    protocol        = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_security_group" "rds_db_security_group" {
  name        = "${local.project_name}-db-sg"
  description = "RDS database security group."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "HTTPS ingress traffic from ECS containers."
    security_groups = [aws_security_group.security_group.id]
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}




