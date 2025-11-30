# ==============================================================================
# FFD DEV ENVIRONMENT (US-EAST-1)
#
# This file serves as the entry point for the dev environment in the us-east-1
# region, orchestrating the deployment of all infrastructure components.
# ==============================================================================

# ----------------------------------------------------
# 1. TERRAFORM BLOCK (State and Providers)
#
# FIX: Removed the 'backend "s3"' block to avoid the "Backend configuration
# specified multiple times" error, relying on the CI/CD runner to pass the
# configuration via -backend-config.
# ----------------------------------------------------
terraform {
  required_providers {
    # Specify the required providers for this configuration
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ----------------------------------------------------
# 2. PROVIDER
# ----------------------------------------------------
provider "aws" {
  region = var.region
}

# ----------------------------------------------------
# 3. LOCALS (Configuration Variables)
# ----------------------------------------------------
locals {
  # IAM outputs used for security modules
  admin_group_name = module.iam.admin_group_name
  admin_group_id   = module.iam.admin_group_id
  ops_group_name   = module.iam.ops_group_name
  ops_group_id     = module.iam.ops_group_id
}

# ----------------------------------------------------
# 4. MODULES
# ----------------------------------------------------

# VPC Module
module "vpc" {
  source      = "../../../modules/vpc"
  environment = var.environment
  vpc_cidr    = "10.0.0.0/16"
}

# Subnets Module (Uses specific CIDRs and relies on VPC ID)
module "subnets" {
  source                   = "../../../modules/subnet"
  environment              = var.environment
  vpc_id                   = module.vpc.vpc_id
  public_subnet_cidrs      = { "${var.region}a" = "10.0.1.0/24", "${var.region}b" = "10.0.2.0/24" }
  private_web_subnet_cidrs = { "${var.region}a" = "10.0.11.0/24", "${var.region}b" = "10.0.12.0/24" }
  private_app_subnet_cidrs = { "${var.region}a" = "10.0.21.0/24", "${var.region}b" = "10.0.22.0/24" }
  private_db_subnet_cidrs  = { "${var.region}a" = "10.0.31.0/24", "${var.region}b" = "10.0.32.0/24" }
}

# NAT Gateway Module (Provides internet access to private subnets)
module "nat" {
  source            = "../../../modules/nat"
  environment       = var.environment
  public_subnet_ids = module.subnets.public_subnet_ids
  enable            = var.enable_nat
}

# IAM Module (Defines Users and Groups)
module "iam" {
  source      = "../../../modules/iam"
  environment = var.environment
}

# Routing Module (Route Tables, Routes, and Associations)
module "routing" {
  source                   = "../../../modules/routing"
  environment              = var.environment
  vpc_id                   = module.vpc.vpc_id
  public_subnet_ids        = module.subnets.public_subnet_ids
  private_web_subnet_ids   = module.subnets.private_web_subnet_ids
  private_app_subnet_ids   = module.subnets.private_app_subnet_ids
  private_db_subnet_ids    = module.subnets.private_db_subnet_ids
  enable_nat_gateway       = var.enable_nat
  nat_gateway_ids          = module.nat.nat_gateway_ids
  internet_gateway_id      = module.vpc.internet_gateway_id
  # Note: VPC endpoint IDs are commented out below, assuming they are not yet fully implemented
  # vpce_s3_id               = null
  # vpce_dynamodb_id         = null
  # vpce_ssm_id              = null
  # vpce_ssmmessages_id      = null
  # vpce_ec2messages_id      = null
  # vpce_kms_id              = null
  # vpce_secretsmanager_id   = null
}

# ----------------------------------------------------
# SECURITY GROUPS
# ----------------------------------------------------

module "security_alb_web" {
  source      = "../../../modules/security"
  name        = "alb-web"
  description = "Security group for Web tier ALB"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow inbound HTTP from internet"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ICMP for diagnostics"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}

module "security_alb_app" {
  source      = "../../../modules/security"
  name        = "alb-app"
  description = "Security group for App tier ALB"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      security_groups = [module.security_web.security_group_id]
      description     = "Allow web tier to access app ALB"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Allow ICMP from internal subnets"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}

module "security_web" {
  source      = "../../../modules/security"
  name        = "web"
  description = "Web tier SG"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [module.security_alb_web.security_group_id]
      description     = "Allow HTTP from ALB Web SG"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Allow ICMP from anywhere"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all egress"
    }
  ]
}

module "security_app" {
  source      = "../../../modules/security"
  name        = "app"
  description = "App tier SG"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      security_groups = [module.security_alb_app.security_group_id]
      description     = "Allow HTTP from ALB App SG"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Allow ICMP from anywhere"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all egress"
    }
  ]
}

module "security_db" {
  source      = "../../../modules/security"
  name        = "db"
  description = "DB tier SG"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [module.security_app.security_group_id]
      description     = "Allow PostgreSQL from App tier"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Allow ICMP from anywhere"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all egress"
    }
  ]
}

module "security_internal" {
  source      = "../../../modules/security"
  name        = "internal"
  description = "Internal access SG (e.g., VPC endpoints)"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "TLS from internal subnets"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Allow ICMP from internal subnets"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all egress"
    }
  ]
}

# ----------------------------------------------------
# LOAD BALANCERS
# ----------------------------------------------------

module "alb_web" {
  source             = "../../../modules/alb-web"
  environment        = var.environment
  tier               = "web"
  internal           = false
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = values(module.subnets.public_subnet_ids)
  security_group_ids = [module.security_alb_web.security_group_id]
  target_port        = 80
  health_check_path  = "/"
  enable             = var.enable_alb_web
}

module "alb_app" {
  source             = "../../../modules/alb-app"
  environment        = var.environment
  tier               = "app"
  internal           = true
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = values(module.subnets.private_web_subnet_ids)
  security_group_ids = [module.security_alb_app.security_group_id]
  target_port        = 8080
  health_check_path  = "/"
  enable             = var.enable_alb_app
}

# ----------------------------------------------------
# AUTO SCALING GROUPS
# ----------------------------------------------------

module "asg_web" {
  source             = "../../../modules/asg-web"
  environment        = var.environment
  subnet_ids         = values(module.subnets.private_web_subnet_ids)
  security_group_ids = [module.security_web.security_group_id]
  target_group_arn   = module.alb_web.target_group_arn
  ami_id             = var.ami_id_web["${var.region}"]
  instance_type      = var.web_instance_type
  user_data_base64   = var.user_data_base64
  desired_capacity   = 0
  min_size           = 0
  max_size           = 0
}

module "asg_app" {
  source             = "../../../modules/asg-app"
  environment        = var.environment
  subnet_ids         = values(module.subnets.private_app_subnet_ids)
  security_group_ids = [module.security_app.security_group_id]
  target_group_arn   = module.alb_app.target_group_arn
  ami_id             = var.ami_id_app["${var.region}"]
  instance_type      = var.app_instance_type
  user_data_base64   = var.user_data_base64
  desired_capacity   = 0
  min_size           = 0
  max_size           = 0
}

# ----------------------------------------------------
# UTILITY/SERVICE RESOURCES
# ----------------------------------------------------

module "ec2" {
  source             = "../../../modules/ec2"
  environment        = var.environment
  ami_id             = var.ami_id_web["${var.region}"]
  instance_type      = var.ec2_instance_type
  name               = "ami-builder"
  subnet_id          = module.subnets.private_web_subnet_ids["us-east-1a"]
  security_group_ids = [module.security_web.security_group_id]
  enable             = var.enable_ec2
}

module "ssm" {
  source             = "../../../modules/ssm"
  environment        = var.environment
  region             = var.region
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = values(module.subnets.private_app_subnet_ids)
  security_group_ids = [module.security_app.security_group_id]
  enable             = var.enable_ssm
}

module "web_s3_bucket" {
  source      = "../../../modules/s3"
  environment = var.environment
  region      = var.region
  bucket_name = "ffd-web-data-${var.environment}-${var.region}-5766"
}

module "app_s3_bucket" {
  source      = "../../../modules/s3"
  environment = var.environment
  region      = var.region
  bucket_name = "ffd-app-data-${var.environment}-7714022395766-${var.region}"
}