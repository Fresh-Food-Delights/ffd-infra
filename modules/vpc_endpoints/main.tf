# /modules/vpc_endpoints/main.tf
  
terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  common_tags = {
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3 ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  tags = merge(local.common_tags, {
    Name = "ffd-${var.environment}-vpce-s3"
  })
}

resource "aws_vpc_endpoint" "dynamodb" {
  count             = var.enable_dynamodb ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  tags = merge(local.common_tags, {
    Name = "ffd-${var.environment}-vpce-dynamodb"
  })
}

resource "aws_vpc_endpoint" "ssm" {
  count             = var.enable_ssm ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.private_subnet_ids
  security_group_ids = var.security_group_ids
  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "ffd-${var.environment}-vpce-ssm"
  })
}

resource "aws_vpc_endpoint" "ssmmessages" {
  count             = var.enable_ssm ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.private_subnet_ids
  security_group_ids = var.security_group_ids
  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "ffd-${var.environment}-vpce-ssmmessages"
  })
}

resource "aws_vpc_endpoint" "ec2messages" {
  count             = var.enable_ssm ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.private_subnet_ids
  security_group_ids = var.security_group_ids
  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "ffd-${var.environment}-vpce-ec2messages"
  })
}

resource "aws_vpc_endpoint" "secretsmanager" {
  count             = var.enable_secretsmanager ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.private_subnet_ids
  security_group_ids = var.security_group_ids
  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "ffd-${var.environment}-vpce-secretsmanager"
  })
}
