resource "aws_security_group" "security_group" {
  name        = "${local.project_name}-asg-sg"
  description = "EC2 security group for Autoscaling group instances."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS ingress traffic."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP ingress traffic."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}


