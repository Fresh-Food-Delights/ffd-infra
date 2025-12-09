# /modules/secrets/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}

locals {
  secret_name = var.secret_name != "" ? var.secret_name : "ffd-db-credentials-${var.environment}-${var.region}"
}

resource "random_password" "app" {
  length  = 24
  special = true
}

resource "aws_secretsmanager_secret" "db" {
  name        = local.secret_name
  description = "App DB credentials for FFD ${var.environment} in ${var.region}"
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
  }
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.app.result
  })
}

resource "aws_vpc_endpoint" "secretsmanager" {
  count               = var.enable_rds ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = "app"
    Name        = "ffd-${var.environment}-vpce-secretsmanager"
  }
}
