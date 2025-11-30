# ==============================================================================
# CORE VPC DEFINITION
# ==============================================================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "ffd-${var.environment}-vpc"
    Environment = var.environment
  }
}

# ==============================================================================
# INTERNET GATEWAY (IGW)
# ==============================================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "ffd-${var.environment}-igw"
    Environment = var.environment
  }
}

# NOTE: ALL VPC ENDPOINT DEFINITIONS SHOULD BE IN modules/vpc/endpoints.tf
# DO NOT ADD VPC ENDPOINT RESOURCES HERE