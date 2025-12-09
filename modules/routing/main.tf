# /modules/routing/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier_public
    Name        = "${var.environment}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route_table_association" "public" {
  for_each       = var.public_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_web" {
  vpc_id = var.vpc_id
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier_private-web
    Name        = "${var.environment}-private-web-rt"
  }
}

resource "aws_route" "private_web_nat" {
  count = var.enable_nat_gateway && length(var.nat_gateway_ids) > 0 ? 1 : 0
  route_table_id         = aws_route_table.private_web.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[0]
}

resource "aws_route_table_association" "private_web" {
  for_each       = var.private_web_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private_web.id
}

resource "aws_route_table" "private_app" {
  vpc_id = var.vpc_id
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier_private-app
    Name        = "${var.environment}-private-app-rt"
  }
}

resource "aws_route_table_association" "private_app" {
  for_each       = var.private_app_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table" "private_db" {
  vpc_id = var.vpc_id
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier_private-db
    Name        = "${var.environment}-private-db-rt"
  }
}

resource "aws_route_table_association" "private_db" {
  for_each       = var.private_db_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private_db.id
}
