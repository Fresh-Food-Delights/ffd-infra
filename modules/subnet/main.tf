# /modules/subnet/main.tf

# Public Subnets (1 per AZ)
resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs

  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags                    = {
    Name = "ffd-${var.environment}-public-${each.key}"
    Tier = "public"
  }
}

# Private Web Subnets (1 per AZ)
resource "aws_subnet" "private_web" {
  for_each = var.private_web_subnet_cidrs

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key
  tags              = {
    Name = "ffd-${var.environment}-web-${each.key}"
    Tier = "private-web"
  }
}

# Private App Subnets (1 per AZ)
resource "aws_subnet" "private_app" {
  for_each = var.private_app_subnet_cidrs

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key
  tags              = {
    Name = "ffd-${var.environment}-app-${each.key}"
    Tier = "private-app"
  }
}

# Private DB Subnets (1 per AZ)
resource "aws_subnet" "private_db" {
  for_each = var.private_db_subnet_cidrs

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key
  tags              = {
    Name = "ffd-${var.environment}-db-${each.key}"
    Tier = "private-db"
  }
}
