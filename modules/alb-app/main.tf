# modules/alb-app/main.tf

resource "aws_lb" "this" {
  count              = var.enable ? 1 : 0
  name               = "ffd-${var.environment}-app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false
  idle_timeout                = 60

  tags = {
    Name        = "ffd-${var.environment}-app-alb"
    Environment = var.environment
    Tier        = var.tier
  }
}

resource "aws_lb_target_group" "this" {
  count    = var.enable ? 1 : 0
  name     = "ffd-${var.environment}-app-tg"
  port     = var.target_port
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "HTTPS"
    path                = var.health_check_path
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "ffd-${var.environment}-app-tg"
    Environment = var.environment
    Tier        = var.tier
  }
}

resource "aws_lb_listener" "https" {
  count             = var.enable ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = var.target_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }
}
