# ==============================================================================
# ROUTING MODULE CORE LOGIC
#
# This module defines the Route Tables and all associated routes and associations
# for the Public, Web, App, and DB tiers.
# ==============================================================================

# ----------------------------------------------------
# 1. Route Table Definitions
# ----------------------------------------------------

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags   = {
    Name = "ffd-${var.environment}-public"
    Tier = "public"
  }
}

# Private Web Tier Route Table
resource "aws_route_table" "private_web" {
  vpc_id = var.vpc_id
  tags   = {
    Name = "ffd-${var.environment}-private-web"
    Tier = "private-web"
  }
}

# Private App Tier Route Table
resource "aws_route_table" "private_app" {
  vpc_id = var.vpc_id
  tags   = {
    Name = "ffd-${var.environment}-private-app"
    Tier = "private-app"
  }
}

# Private DB Tier Route Table
resource "aws_route_table" "private_db" {
  vpc_id = var.vpc_id
  tags   = {
    Name = "ffd-${var.environment}-private-db"
    Tier = "private-db"
  }
}

# ----------------------------------------------------
# 2. VPC ENDPOINT ROUTES (Gateway Endpoints: S3, DynamoDB)
#
# Uses the 'aws_vpc_endpoint_route_table_association' resource to manage 
# Gateway Endpoints in the designated route tables.
# ----------------------------------------------------

# --- S3 Gateway Endpoint Routes ---
# S3 for Private Web
resource "aws_vpc_endpoint_route_table_association" "s3_private_web" {
  route_table_id  = aws_route_table.private_web.id
  vpc_endpoint_id = var.vpce_s3_id
}

# S3 for Private App
resource "aws_vpc_endpoint_route_table_association" "s3_private_app" {
  route_table_id  = aws_route_table.private_app.id
  vpc_endpoint_id = var.vpce_s3_id
}

# S3 for Private DB
resource "aws_vpc_endpoint_route_table_association" "s3_private_db" {
  route_table_id  = aws_route_table.private_db.id
  vpc_endpoint_id = var.vpce_s3_id
}


# --- DynamoDB Gateway Endpoint Routes ---
# DynamoDB for Private Web
resource "aws_vpc_endpoint_route_table_association" "dynamodb_private_web" {
  route_table_id  = aws_route_table.private_web.id
  vpc_endpoint_id = var.vpce_dynamodb_id
}

# DynamoDB for Private App
resource "aws_vpc_endpoint_route_table_association" "dynamodb_private_app" {
  route_table_id  = aws_route_table.private_app.id
  vpc_endpoint_id = var.vpce_dynamodb_id
}

# DynamoDB for Private DB
resource "aws_vpc_endpoint_route_table_association" "dynamodb_private_db" {
  route_table_id  = aws_route_table.private_db.id
  vpc_endpoint_id = var.vpce_dynamodb_id
}

# ----------------------------------------------------
# 3. DEFAULT ROUTES (Internet Gateway and NAT Gateway)
# ----------------------------------------------------

# Route: Public Tier to Internet Gateway (IGW)
resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
  count                  = var.enable_public_internet ? 1 : 0
}

# Routes: Private Tiers to NAT Gateway (using for_each to handle multiple NATs/AZs)
# Note: Since the NAT GW is associated with the Private Subnet ID map in the main.tf, 
# we need to ensure the route table gets the correct NAT ID per AZ. We'll iterate
# over the NAT GW IDs and associate the route with the private route tables. 
# This requires a more complex structure than iterating over the NAT GW IDs directly.

locals {
  # We will use the count meta-argument for the private route definitions for simplicity
  # as 'for_each' on a single route table ID per tier is difficult with multiple NAT IDs.
  # The environment should pass NAT GW IDs as a list, one per AZ.
  nat_count = length(var.nat_gateway_ids)
}

# Routes for Private Web (to NAT)
resource "aws_route" "web_nat" {
  count                  = local.nat_count
  route_table_id         = aws_route_table.private_web.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[count.index] # Should point to the right NAT GW ID
}

# Routes for Private App (to NAT)
resource "aws_route" "app_nat" {
  count                  = local.nat_count
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[count.index] # Should point to the right NAT GW ID
}

# Routes for Private DB (to NAT)
resource "aws_route" "db_nat" {
  count                  = local.nat_count
  route_table_id         = aws_route_table.private_db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[count.index] # Should point to the right NAT GW ID
}


# ----------------------------------------------------
# 4. Route Table Associations
# ----------------------------------------------------

# Route Table Associations (Public)
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# Associations (Private Web)
resource "aws_route_table_association" "private_web" {
  for_each       = var.private_web_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private_web.id
}

# Associations (Private App)
resource "aws_route_table_association" "private_app" {
  for_each       = var.private_app_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private_app.id
}

# Associations (Private DB)
resource "aws_route_table_association" "private_db" {
  for_each       = var.private_db_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private_db.id
}