# /modules/subnet/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs
  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags                    = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier_public
    Name        = "ffd-${var.environment}-public-${each.key}"
  }
}

resource "aws_subnet" "private_web" {
  for_each = var.private_web_subnet_cidrs
  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key
  tags              = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier_private-web
    Name        = "ffd-${var.environment}-web-${each.key}"
  }
}

resource "aws_subnet" "private_app" {
  for_each = var.private_app_subnet_cidrs
  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key
  tags              = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier_private-app
    Name        = "ffd-${var.environment}-app-${each.key}"
  }
}

resource "aws_subnet" "private_db" {
  for_each = var.private_db_subnet_cidrs
  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key
  tags              = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier_private-db
    Name        = "ffd-${var.environment}-db-${each.key}"
  }
}
