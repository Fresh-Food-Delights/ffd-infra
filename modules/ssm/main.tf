# /modules/ssm/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_vpc_endpoint" "ssm" {
  count               = var.enable ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags                = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name        = "ffd-${var.environment}-ssm-vpce"
  }
}

resource "aws_vpc_endpoint" "ssm_messages" {
  count               = var.enable ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags                = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name        = "ffd-${var.environment}-ssmmessages-vpce"
  }
}

resource "aws_vpc_endpoint" "ec2_messages" {
  count               = var.enable ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = true
  tags                = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Name        = "ffd-${var.environment}-ec2messages-vpce"
  }
}

resource "aws_iam_role" "ssm_instance_role" {
  count              = var.enable ? 1 : 0
  name               = "ffd-${var.environment}-ssm-instance-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  count      = var.enable ? 1 : 0
  role       = aws_iam_role.ssm_instance_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  count = var.enable ? 1 : 0
  name = "ffd-${var.environment}-ssm-instance-profile"
  role = aws_iam_role.ssm_instance_role[0].name
}
