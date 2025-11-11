/*
    Resource: IAM Role
    Description: Creates a task execution role and the permissions 
    required by the ECS Agent to make calls to various AWS services.
 */
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  /*
   *    ALB name identifier
   */
  name = "${local.project_name}-alb"


  /*
   *    ALB type
   */
  internal = false

  /*
   *    Network placement
   */
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets


  /*
   *    Security Groups
   */
  security_group_name = "${local.project_name}-alb-sg"
  security_group_rules = {
    ingress_all_http = {
      type        = "ingress"
      description = "Allow all HTTP traffic"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    ingress_all_https = {
      type        = "ingress"
      description = "Allow all HTTPS traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  # security_group_rules = {
  #   ingress_all_http = {
  #     type        = "ingress"
  #     description = "Allow all HTTP traffic"
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   },
  #   ingress_all_https = {
  #     type        = "ingress"
  #     description = "Allow all HTTPS traffic"
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   },
  #   egress_all = {
  #     type        = "egress"
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # }


  /*
   *    HTTPS listeners
   */
  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = "${aws_acm_certificate.ks_acm_certificate.arn}"
      action_type     = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Forbidden"
        status_code  = "403"
      }

      # default_action = {
      #   type         = "fixed-response"
      #   message_body = "Forbidden"
      #   status_code  = 403
      # }
    }
  ]

  /*
   *    HTTP listeners
   */

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  /*
   *    Target groups
   */

  target_groups = [
    {
      name_prefix      = "cms-"
      backend_protocol = "HTTP"
      backend_port     = 1337
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/admin"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    },
  ]

  /*
   *    HTTPs listener rules
   */
  https_listener_rules = [
    /*
     * CMS 
     */
    {
      https_listener_index = 0
      priority             = 1
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]

      conditions = [
        {
          host_headers = ["cms.siba.${aws_route53_zone.ks_route53_public_hosted_zone.name}"]
        },
        # {
        #   http_headers = [
        #     {
        #       http_header_name = "X-Edge-Auth"
        #       values           = ["cdpedgepath"]
        #     }
        #   ]
        # }
      ]
    }
  ]

}