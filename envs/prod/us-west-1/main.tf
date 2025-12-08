# /envs/prod/us-west-1/main.tf

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
  vpc_cidr    = "10.1.0.0/16"
}

module "vpc_endpoints" {
  source             = "../../../modules/vpc_endpoints"
  environment        = var.environment
  region             = var.region
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = values(module.subnets.private_app_subnet_ids)
  private_route_table_ids = [
    module.routing.private_web_route_table_id,
    module.routing.private_app_route_table_id,
    module.routing.private_db_route_table_id,
  ]
  security_group_ids = [module.security_internal.security_group_id]
}

module "subnets" {
  source                   = "../../../modules/subnet"
  environment              = var.environment
  vpc_id                   = module.vpc.vpc_id
  public_subnet_cidrs      = { "${var.region}a" = "10.1.1.0/24", "${var.region}c" = "10.1.2.0/24" }
  private_web_subnet_cidrs = { "${var.region}a" = "10.1.11.0/24", "${var.region}c" = "10.1.12.0/24" }
  private_app_subnet_cidrs = { "${var.region}a" = "10.1.21.0/24", "${var.region}c" = "10.1.22.0/24" }
  private_db_subnet_cidrs  = { "${var.region}a" = "10.1.31.0/24", "${var.region}c" = "10.1.32.0/24" }
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
      cidr_blocks = ["10.1.0.0/16"]
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
      cidr_blocks = ["10.1.0.0/16"]
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
      cidr_blocks = ["10.1.0.0/16"]
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
      cidr_blocks = ["10.1.0.0/16"]
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
      cidr_blocks = ["10.1.0.0/16"]
      description = "TLS from internal subnets"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["10.1.0.0/16"]
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
  source               = "../../../modules/asg-web"
  environment          = var.environment
  subnet_ids           = values(module.subnets.private_web_subnet_ids)
  security_group_ids   = [module.security_web.security_group_id]
  target_group_arn     = module.alb_web.target_group_arn
  ami_id               = var.ami_id_web["${var.region}"]
  instance_type        = var.web_instance_type
  user_data_base64     = var.user_data_base64
  iam_instance_profile = data.terraform_remote_state.prod_us-east-1_outputs.outputs.web_instance_profile_name
  desired_capacity     = 0
  min_size             = 0
  max_size             = 0
}

module "asg_app" {
  source               = "../../../modules/asg-app"
  environment          = var.environment
  subnet_ids           = values(module.subnets.private_app_subnet_ids)
  security_group_ids   = [module.security_app.security_group_id]
  target_group_arn     = module.alb_app.target_group_arn
  ami_id               = var.ami_id_app["${var.region}"]
  instance_type        = var.app_instance_type
  user_data_base64     = var.user_data_base64
  iam_instance_profile = data.terraform_remote_state.prod_us-east-1_outputs.outputs.app_instance_profile_name
  desired_capacity     = 0
  min_size             = 0
  max_size             = 0
}

module "ec2" {
  source             = "../../../modules/ec2"
  environment        = var.environment
  tier               = "web"
  ami_id             = var.ami_id_app["${var.region}"]
  instance_type      = var.ec2_instance_type
  name               = "ami-builder"
  subnet_id          = module.subnets.private_web_subnet_ids["${var.region}a"]
  security_group_ids = [module.security_web.security_group_id]
  enable             = var.enable_ec2
}

module "ssm" {
  source             = "../../../modules/ssm"
  environment        = var.environment
  region             = var.region
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = values(module.subnets.private_app_subnet_ids)
  security_group_ids = [module.security_internal.security_group_id]
  enable             = var.enable_ssm
}

module "web_s3_bucket" {
  source      = "../../../modules/s3"
  environment = var.environment
  region      = var.region
  tier        = "web"
  account_id  = var.account_id
  bucket_name = "ffd-data-web-${var.environment}-${var.account_id}-${var.region}"
}

module "app_s3_bucket" {
  source      = "../../../modules/s3"
  environment = var.environment
  region      = var.region
  tier        = "app"
  account_id  = var.account_id
  bucket_name = "ffd-data-app-${var.environment}-${var.account_id}-${var.region}"
}

module "db_secrets" {
  source      = "../../../modules/db_secrets"
  environment = var.environment
  region      = var.region
  db_username = var.db_username
}

module "rds" {
  source                = "../../../modules/rds"
  environment           = var.environment
  region                = var.region
  tier                  = "db"
  db_instance_type      = var.db_instance_type
  db_subnet_ids         = values(module.subnets.private_db_subnet_ids)
  db_security_group_ids = [module.security_db.security_group_id]
  multi_az              = var.multi_az
  is_replica            = var.is_replica
  primary_instance_arn = try(
    data.terraform_remote_state.prod_us-east-1_outputs.outputs["primary_instance_arn"],
    ""
  )
  db_username = "${var.db_username}-${var.environment}"
  enable      = var.enable_rds
}

data "aws_dynamodb_table" "sessions" {
  name = "ffd-sessions-prod"
}

data "terraform_remote_state" "prod_us-east-1_outputs" {
  backend = "s3"
  config = {
    bucket = "ffd-tfstate-771402395766-us-east-1"
    key    = "envs/prod/us-east-1/terraform.tfstate"
    region = "us-east-1"
  }
}
