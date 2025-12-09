# /modules/vpc_endpoints/main.tf
  
terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = var.private_route_table_ids
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name = "ffd-${var.environment}-vpce-s3"
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids = var.private_route_table_ids
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name = "ffd-${var.environment}-vpce-dynamodb"
  }
}
