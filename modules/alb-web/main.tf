# modules/alb-web/main.tf

resource "aws_lb" "this" {
  name               = "ffd-${var.environment}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false
  idle_timeout                = 60

  tags = {
    Name        = "ffd-${var.environment}-web-alb"
    Environment = var.environment
    Tier        = "web"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "ffd-${var.environment}-web-tg"
  port     = 443
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
    Name        = "ffd-${var.environment}-web-tg"
    Environment = var.environment
    Tier        = "web"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
