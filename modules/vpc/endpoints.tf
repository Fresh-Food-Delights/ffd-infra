# Define the Security Group for Interface Endpoints (Secrets Manager, SSM)
resource "aws_security_group" "vpc_endpoint_sg" {
  name_prefix = "vpc-endpoint-sg"
  vpc_id      = aws_vpc.main.id 

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block] # Allows HTTPS access from within the VPC
    description = "Allow HTTPS from within VPC for Endpoints"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

# Local variable to combine all private subnet IDs for Interface Endpoints
locals {
  all_private_subnet_ids = concat(
    var.private_web_subnet_ids,
    var.private_app_subnet_ids,
    var.private_db_subnet_ids
  )
}

# --- Gateway Endpoints (Route Table Injection) ---

# 1. S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  
  # Inject endpoint into all three private route tables
  route_table_ids   = [
    aws_route_table.private_web.id, 
    aws_route_table.private_app.id, 
    aws_route_table.private_db.id 
  ]
}

# 2. DynamoDB Gateway Endpoint
resource "aws_vpc_endpoint" "dynamodb_gateway" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  
  # Inject endpoint into all three private route tables
  route_table_ids   = [
    aws_route_table.private_web.id, 
    aws_route_table.private_app.id, 
    aws_route_table.private_db.id 
  ]
}

# --- Interface Endpoints (ENI/IP based) ---

# 3. Secrets Manager Interface
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.all_private_subnet_ids # Use the combined list
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}

# 4. SSM (Systems Manager) Interface
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.all_private_subnet_ids 
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}

# 5. SSMMESSAGES Interface (Required for Session Manager)
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.all_private_subnet_ids 
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}
