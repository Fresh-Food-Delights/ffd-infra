# CORE VPC DEFINITION
resource "aws_vpc" "main" {
  cidr_block         = var.vpc_cidr
  instance_tenancy   = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name        = "ffd-${var.environment}-vpc"
    Environment = var.environment
  }
}

# INTERNET GATEWAY (IGW)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "ffd-${var.environment}-igw"
    Environment = var.environment
  }
}

# The VPC endpoints are now defined in the 'vpc_endpoints' submodule.
# This locals block is no longer needed in the parent VPC module 
# and has been deleted to resolve duplicate definition errors.

# NOTE: ALL VPC ENDPOINT DEFINITIONS SHOULD BE IN module/vpc_endpoints
# DO NOT ADD VPC ENDPOINT RESOURCES OR LOCALS HERE