# modules/asg-web/main.tf

resource "aws_launch_template" "this" {
  name_prefix   = "ffd-${var.environment}-web-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.security_group_ids
  }

  user_data = var.user_data_base64

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "ffd-${var.environment}-web"
      Environment = var.environment
      Tier        = "web"
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
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ffd-${var.environment}-web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "web"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
