# /modules/asg-web/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "ffd-${var.environment}-web-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.security_group_ids
  }
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  user_data = var.user_data_base64
  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = var.environment
      Region      = var.region
      Tier        = var.tier
      Name        = "ffd-${var.environment}-web"
    }
  }

}

resource "aws_autoscaling_group" "this" {
  name                      = "ffd-${var.environment}-asg-web"
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 30
  target_group_arns = var.target_group_arn != null ? [var.target_group_arn] : []
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  tag {
    key                 = "Region"
    value               = var.region
    propagate_at_launch = true
  }
  tag {
    key                 = "Tier"
    value               = var.tier
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "ffd-${var.environment}-web"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
