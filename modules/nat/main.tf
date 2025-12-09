# /modules/nat/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_eip" "this" {
  for_each = var.enable ? var.public_subnet_ids : {}
  domain   = "vpc"
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name = "ffd-${var.environment}-nat-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each          = var.enable ? var.public_subnet_ids : {}
  allocation_id     = aws_eip.this[each.key].id
  subnet_id         = each.value
  connectivity_type = "public"
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name = "ffd-${var.environment}-natgw-${each.key}"
  }
  depends_on = [aws_eip.this]
}
