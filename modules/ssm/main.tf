# /modules/ssm/main.tf

resource "aws_vpc_endpoint" "ssm" {
  count               = var.enable ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags                = {
    Name        = "ffd-${var.environment}-ssm"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  count               = var.enable ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags                = {
    Name        = "ffd-${var.environment}-ssmmessages"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  count               = var.enable ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags                = {
    Name        = "ffd-${var.environment}-ec2messages"
    Environment = var.environment
  }
}
