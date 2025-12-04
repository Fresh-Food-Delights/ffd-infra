# -----------------------------------------------------------------------------
# VPC ENDPOINTS
# Defines all the VPC Endpoints for private AWS service access.
# -----------------------------------------------------------------------------

# Data source for the current AWS region is required for service names
data "aws_region" "current" {}

# Local variables to combine all private subnet IDs for Interface Endpoints
# This simplifies the configuration of ENI-based endpoints.
locals {
  all_private_subnet_ids = concat(
    var.private_web_subnet_ids,
    var.private_app_subnet_ids,
    var.private_db_subnet_ids
  )
}

# -----------------------------------------------------------------------------
# 1. Gateway Endpoints (S3 and DynamoDB)
# -----------------------------------------------------------------------------

# Gateway Endpoint for S3
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id          = var.vpc_id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  
  # A policy is required to allow access from the VPC to the service
  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
    }
  ]
}
POLICY

  tags = {
    Name        = "vpce-s3-gateway-${var.environment}"
    Environment = var.environment
  }
}

# Gateway Endpoint for DynamoDB
resource "aws_vpc_endpoint" "dynamodb_gateway" {
  vpc_id          = var.vpc_id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  
  # A policy is required to allow access from the VPC to the service
  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
    }
  ]
}
POLICY

  tags = {
    Name        = "vpce-dynamodb-gateway-${var.environment}"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------------------
# 2. Interface Endpoints (SecretsManager, SSM, etc.)
# -----------------------------------------------------------------------------

# Interface Endpoint for Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_endpoint_type  = "Interface"
  private_dns_enabled = true 

  # Place the ENIs in all private subnets using the local variable
  subnet_ids = local.all_private_subnet_ids
  
  # Attach the Security Group provided by the parent module
  security_group_ids = [var.vpc_endpoint_security_group_id]

  tags = {
    Name        = "vpce-secretsmanager-${var.environment}"
    Environment = var.environment
  }
}

# Interface Endpoint for SSM (Systems Manager Manager)
resource "aws_vpc_endpoint" "ssm" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type  = "Interface"
  private_dns_enabled = true

  subnet_ids         = local.all_private_subnet_ids
  security_group_ids = [var.vpc_endpoint_security_group_id]

  tags = {
    Name        = "vpce-ssm-${var.environment}"
    Environment = var.environment
  }
}

# Interface Endpoint for SSMMESSAGES (Required for Session Manager)
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type  = "Interface"
  private_dns_enabled = true

  subnet_ids         = local.all_private_subnet_ids
  security_group_ids = [var.vpc_endpoint_security_group_id]

  tags = {
    Name        = "vpce-ssmmessages-${var.environment}"
    Environment = var.environment
  }
}

# Interface Endpoint for EC2MESSAGES (Required for Session Manager)
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type  = "Interface"
  private_dns_enabled = true

  subnet_ids         = local.all_private_subnet_ids
  security_group_ids = [var.vpc_endpoint_security_group_id]

  tags = {
    Name        = "vpce-ec2messages-${var.environment}"
    Environment = var.environment
  }
}