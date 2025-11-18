# envs/prod/us-east-1.tf

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
  vpc_cidr  = "10.0.0.0/16"
}

module "subnets" {
  source                    = "../../modules/subnet"
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  public_subnet_cidrs       = { "us-east-1a" = "10.0.1.0/24", "us-east-1b" = "10.0.2.0/24" }
  private_web_subnet_cidrs  = { "us-east-1a" = "10.0.11.0/24", "us-east-1b" = "10.0.12.0/24" }
  private_app_subnet_cidrs  = { "us-east-1a" = "10.0.21.0/24", "us-east-1b" = "10.0.22.0/24" }
  private_db_subnet_cidrs   = { "us-east-1a" = "10.0.31.0/24", "us-east-1b" = "10.0.32.0/24" }
}

module "nat" {
  source            = "../../modules/nat"
  environment       = var.environment
  public_subnet_ids = module.subnets.public_subnet_ids
  enable            = var.enable_nat
}

module "routing" {
  source                       = "../../modules/routing"
  environment                  = var.environment
  vpc_id                       = module.vpc.vpc_id
  public_subnet_ids            = module.subnets.public_subnet_ids
  private_web_subnet_ids       = module.subnets.private_web_subnet_ids
  private_app_subnet_ids       = module.subnets.private_app_subnet_ids
  private_db_subnet_ids        = module.subnets.private_db_subnet_ids
  enable_nat_gateway           = var.enable_nat
  nat_gateway_ids              = module.nat.nat_gateway_ids
  internet_gateway_id          = module.vpc.internet_gateway_id
  web_cidr_block               = "10.0.11.0/24"
  app_cidr_block               = "10.0.21.0/24"
  db_cidr_block                = "10.0.31.0/24"
  vpce_s3_id                   = null
  vpce_dynamodb_id             = null
  vpce_ssm_id                  = null
  vpce_ssmmessages_id          = null
  vpce_ec2messages_id          = null
  vpce_kms_id                  = null
  vpce_secretsmanager_id       = null
}

module "security_web" {
  source        = "../../modules/security"
  name          = "web"
  description   = "Web tier SG"
  environment   = var.environment
  vpc_id        = module.vpc.vpc_id
  ingress_rules = []
  egress_rules  = []
}

module "security_app" {
  source        = "../../modules/security"
  name          = "app"
  description   = "App tier SG"
  environment   = var.environment
  vpc_id        = module.vpc.vpc_id
  ingress_rules = []
  egress_rules  = []
}

module "alb_web" {
  source              = "../../modules/alb-web"
  environment         = var.environment
  tier                = "web"
  internal            = false
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.subnets.public_subnet_ids
  security_group_ids  = [module.security_web.security_group_id]
  target_port         = 443
  health_check_path   = "/"
  acm_cert_arn        = var.acm_cert_arn
  enable              = var.enable_alb_web
}

module "alb_app" {
  source              = "../../modules/alb-app"
  environment         = var.environment
  tier                = "app"
  internal            = true
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.subnets.private_web_subnet_ids
  security_group_ids  = [module.security_app.security_group_id]
  target_port         = 8443
  health_check_path   = "/"
  acm_cert_arn        = var.acm_cert_arn
  enable              = var.enable_alb_app
}

module "asg_web" {
  source               = "../../modules/asg-web"
  environment          = var.environment
  subnet_ids           = module.subnets.private_web_subnet_ids
  security_group_ids   = [module.security_web.security_group_id]
  target_group_arn     = module.alb_web.target_group_arn
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  user_data_base64     = var.user_data_base64
  desired_capacity     = 0
  min_size             = 0
  max_size             = 0
}

module "asg_app" {
  source               = "../../modules/asg-app"
  environment          = var.environment
  subnet_ids           = module.subnets.private_app_subnet_ids
  security_group_ids   = [module.security_app.security_group_id]
  target_group_arn     = module.alb_app.target_group_arn
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  user_data_base64     = var.user_data_base64
  desired_capacity     = 0
  min_size             = 0
  max_size             = 0
}

module "ec2" {
  source              = "../../modules/ec2"
  environment         = var.environment
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  name                = "ami-builder"
  subnet_id           = module.subnets.private_web_subnet_ids["us-east-1a"]
  security_group_ids  = [module.security_web.security_group_id]
  enable              = var.enable_ec2
}

module "ssm" {
  source              = "../../modules/ssm"
  environment         = var.environment
  enable              = var.enable_ssm
  region              = var.aws_region
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.subnets.private_app_subnet_ids
  security_group_ids  = [module.security_app.security_group_id]
}
