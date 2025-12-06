# /envs/test/us-east-1/main.tf

terraform {
  required_version = ">= 1.10"
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source      = "../../../modules/vpc"
  environment = var.environment
  vpc_cidr    = "10.0.0.0/16"
}

module "subnets" {
  source                   = "../../../modules/subnet"
  environment              = var.environment
  vpc_id                   = module.vpc.vpc_id
  public_subnet_cidrs      = { "${var.region}a" = "10.0.1.0/24", "${var.region}b" = "10.0.2.0/24" }
  private_web_subnet_cidrs = { "${var.region}a" = "10.0.11.0/24", "${var.region}b" = "10.0.12.0/24" }
  private_app_subnet_cidrs = { "${var.region}a" = "10.0.21.0/24", "${var.region}b" = "10.0.22.0/24" }
  private_db_subnet_cidrs  = { "${var.region}a" = "10.0.31.0/24", "${var.region}b" = "10.0.32.0/24" }
}

module "nat" {
  source            = "../../../modules/nat"
  environment       = var.environment
  public_subnet_ids = module.subnets.public_subnet_ids
  enable            = var.enable_nat
}

module "routing" {
  source                 = "../../../modules/routing"
  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.subnets.public_subnet_ids
  private_web_subnet_ids = module.subnets.private_web_subnet_ids
  private_app_subnet_ids = module.subnets.private_app_subnet_ids
  private_db_subnet_ids  = module.subnets.private_db_subnet_ids
  enable_nat_gateway     = var.enable_nat
  nat_gateway_ids        = module.nat.nat_gateway_ids
  internet_gateway_id    = module.vpc.internet_gateway_id
  #  vpce_s3_id             = null
  #  vpce_dynamodb_id       = null
  #  vpce_ssm_id            = null
  #  vpce_ssmmessages_id    = null
  #  vpce_ec2messages_id    = null
  #  vpce_secretsmanager_id = null
}

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

module "ec2" {
  source             = "../../../modules/ec2"
  environment        = var.environment
  ami_id             = var.ami_id_app["${var.region}"]
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
  bucket_name = "ffd-web-data-${var.environment}-771402395766-${var.region}"
}

module "app_s3_bucket" {
  source      = "../../../modules/s3"
  environment = var.environment
  region      = var.region
  bucket_name = "ffd-app-data-${var.environment}-771402395766-${var.region}"
}
