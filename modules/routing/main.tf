# modules/routing/main.tf

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = {
    Name = "ffd-${var.environment}-public"
    Tier = "public"
  }
}

resource "aws_route_table" "private_web" {
  vpc_id = var.vpc_id
  tags = {
    Name = "ffd-${var.environment}-private-web"
    Tier = "private-web"
  }
}

resource "aws_route_table" "private_app" {
  vpc_id = var.vpc_id
  tags = {
    Name = "ffd-${var.environment}-private-app"
    Tier = "private-app"
  }
}

resource "aws_route_table" "private_db" {
  vpc_id = var.vpc_id
  tags = {
    Name = "ffd-${var.environment}-private-db"
    Tier = "private-db"
  }
}

# Routes for Public Tier (to IGW)
resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
  count                  = var.enable_public_internet ? 1 : 0
}

# Routes for Private Web (to NAT and App tier)
resource "aws_route" "web_nat" {
  for_each = var.enable_nat_gateway ? var.nat_gateway_ids : {}
  route_table_id         = aws_route_table.private_web.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value
}

## Route from Web Tier to S3 (via VPCe)
#resource "aws_route" "web_to_s3" {
#  count                  = var.vpce_s3_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_web.id
#  destination_cidr_block = "s3"
#  vpc_endpoint_id        = var.vpce_s3_id
#}

resource "aws_route" "web_to_app" {
  route_table_id         = aws_route_table.private_web.id
  destination_cidr_block = var.app_cidr_block
}

#resource "aws_route" "web_to_ssm" {
#  count                  = var.vpce_ssm_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_web.id
#  destination_cidr_block = "ssm"
#  vpc_endpoint_id        = var.vpce_ssm_id
#}
#resource "aws_route" "web_to_ssmmessages" {
#  count                  = var.vpce_ssmmessages_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_web.id
#  destination_cidr_block = "ssmmessages"
#  vpc_endpoint_id        = var.vpce_ssmmessages_id
#}
#resource "aws_route" "web_to_ec2messages" {
#  count                  = var.vpce_ec2messages_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_web.id
#  destination_cidr_block = "ec2messages"
#  vpc_endpoint_id        = var.vpce_ec2messages_id
#}

# Routes for Private App (to Web + DB + VPCe)
resource "aws_route" "app_to_web" {
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = var.web_cidr_block
}

resource "aws_route" "app_to_db" {
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = var.db_cidr_block
}

#resource "aws_route" "app_to_s3" {
#  count                  = var.vpce_s3_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_app.id
#  destination_cidr_block = "s3"
#  vpc_endpoint_id        = var.vpce_s3_id
#}

#resource "aws_route" "app_to_dynamodb" {
#  count                  = var.vpce_dynamodb_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_app.id
#  destination_cidr_block = "dynamodb"
#  vpc_endpoint_id        = var.vpce_dynamodb_id
#}

#resource "aws_route" "app_to_ssm" {
#  count                  = var.vpce_ssm_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_app.id
#  destination_cidr_block = "ssm"
#  vpc_endpoint_id        = var.vpce_ssm_id
#}

#resource "aws_route" "app_to_secrets" {
#  count                  = var.vpce_secretsmanager_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_app.id
#  destination_cidr_block = "secretsmanager"
#  vpc_endpoint_id        = var.vpce_secretsmanager_id
#}

#resource "aws_route" "app_to_kms" {
#  count                  = var.vpce_kms_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_app.id
#  destination_cidr_block = "kms"
#  vpc_endpoint_id        = var.vpce_kms_id
#}

# Routes for Private DB (to App + VPCe)
resource "aws_route" "db_to_app" {
  route_table_id         = aws_route_table.private_db.id
  destination_cidr_block = var.app_cidr_block
}

#resource "aws_route" "db_to_s3" {
#  count                  = var.vpce_s3_id != null ? 1 : 0
#  route_table_id         = aws_route_table.private_db.id
#  destination_cidr_block = "s3"
#  vpc_endpoint_id        = var.vpce_s3_id
#}

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
