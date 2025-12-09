# /modules/vpc/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name = "ffd-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name = "ffd-${var.environment}-igw"
  }
}
