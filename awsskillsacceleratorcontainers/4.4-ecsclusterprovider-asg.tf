/*
    Resource: Autoscaling Group
    
    Description: Creates an autoscaling group that will be used as capacity provider. ECS managed 
    scaling rules to ensure that provider has the necessary resources capacity required by 
    tasks (containers) running in the cluster.
 */

module "ks_autoscaling_group" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.0.0"

  /*
   *   Name of the autoscaling group
   */
  name = "${local.project_name}-asg"

  /*
     Autoscaling group capacity

     - min size
     - max size
     - desired capacity
   */
  min_size         = 3
  max_size         = 3
  desired_capacity = 3

  /*
   * Instance health checks
   */
  health_check_grace_period = 300
  health_check_type         = "EC2"
  wait_for_capacity_timeout = "10m"

  /*
   * VPC subnet instance placement
   */
  vpc_zone_identifier = module.vpc.private_subnets

  /*
   * Launch template for instances
   */
  launch_template_name        = "${local.project_name}-lt"
  launch_template_description = "ECS autoscaling group launch template."
  update_default_version      = true
  instance_type               = "t3.small"
  image_id                    = local.ecs_ami_al2_x86
  ebs_optimized               = true
  enable_monitoring           = true

  /*
   *  Userdata at EC2 init
   */
  user_data = base64encode(templatefile("${path.module}/4.2-ecsclusterprovideruserdata.tpl", {
    ECS_CLUSTER_NAME = "${aws_ecs_cluster.ks_ecs_cluster.name}"
    TAGS             = local.default_tags
  }))

  /*
   *  IAM Role & instance profile
   */
  create_iam_instance_profile = true
  iam_role_name               = "${local.project_name}-ec2instance-profile"
  iam_role_path               = "/"
  iam_role_description        = "IAM role EC2 instance"

  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    AmazonSSMPatchAssociation           = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation",
    CloudWatchAgentServerPolicy         = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    AmazonEC2ReadOnlyAccess             = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  }


  /*
   *  Network Interface
   */
  network_interfaces = [
    {
      delete_on_termination       = true
      description                 = "eth0"
      associate_public_ip_address = false
      device_index                = 0
      security_groups             = [aws_security_group.security_group.id, module.alb.security_group_id]
    }
  ]

  /*
   * EBS Storage
   */
  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      no_device   = 1
      ebs = {
        device_name           = "/dev/xvda"
        volume_size           = 30
        volume_type           = "gp3"
        delete_on_termination = true
      }
    }
  ]

  /*
   * CPU Options
   */
  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }


  /*
    * ASG Default settings
    */
  protect_from_scale_in = true
  autoscaling_group_tags = {
    AmazonECSManaged = true
  }


  tags = merge(local.default_tags, {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  })

}