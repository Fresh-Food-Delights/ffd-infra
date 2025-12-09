# /modules/ssm/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_vpc_endpoint" "ssm" {
  count               = var.enable ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags                = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name        = "ffd-${var.environment}-ssm-vpce"
  }
}

resource "aws_vpc_endpoint" "ssm_messages" {
  count               = var.enable ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags                = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name        = "ffd-${var.environment}-ssmmessages-vpce"
  }
}

resource "aws_vpc_endpoint" "ec2_messages" {
  count               = var.enable ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags                = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name        = "ffd-${var.environment}-ec2messages-vpce"
  }
}
