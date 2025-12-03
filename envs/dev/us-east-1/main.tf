provider "aws" {
  region = var.region
}

# 1. SUBNETS: MUST be defined first. VPC and Routing depend on its outputs.
module "subnets" {
  source = "../../modules/subnet"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id # Depends on module.vpc
  
  public_subnet_cidrs  = { "${var.region}a" = "10.0.1.0/24", "${var.region}b" = "10.0.2.0/24" }
  private_web_subnet_cidrs = { "${var.region}a" = "10.0.11.0/24", "${var.region}b" = "10.0.12.0/24" }
  private_app_subnet_cidrs = { "${var.region}a" = "10.0.21.0/24", "${var.region}b" = "10.0.22.0/24" }
  private_db_subnet_cidrs  = { "${var.region}a" = "10.0.31.0/24", "${var.region}b" = "10.0.32.0/24" }
}

# 2. VPC SECURITY: Must be defined before VPC, as VPC needs its Security Group ID output.
module "vpc_security" {
  source = "../../modules/vpc_security"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = var.vpc_cidr 
}

# 3. VPC: Can now safely use the outputs of Subnets and VPC Security.
module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr 
  
  # Dependencies now resolve correctly:
  private_web_subnet_ids  = module.subnets.private_web_subnet_ids
  private_app_subnet_ids  = module.subnets.private_app_subnet_ids
  private_db_subnet_ids   = module.subnets.private_db_subnet_ids
  
  # Inject the Security Group ID into the VPC module for use in endpoints.tf
  vpc_endpoint_security_group_id = module.vpc_security.vpc_endpoint_security_group_id 
}

module "nat" {
  source = "../../modules/nat"

  environment         = var.environment
  public_subnet_ids   = module.subnets.public_subnet_ids
  enable              = var.enable_nat
}

module "iam" {
  source = "../../modules/iam"

  environment = var.environment
}

locals {
  admin_group_name = module.iam.admin_group_name
  ops_group_name   = module.iam.ops_group_name
  ops_group_id     = module.iam.ops_group_id
}

module "routing" {
  source = "../../modules/routing"

  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.subnets.public_subnet_ids
  private_web_subnet_ids  = module.subnets.private_web_subnet_ids
  private_app_subnet_ids  = module.subnets.private_app_subnet_ids
  private_db_subnet_ids   = module.subnets.private_db_subnet_ids
  enable_nat_gateway  = var.enable_nat
  nat_gateway_ids     = module.nat.nat_gateway_ids
  internet_gateway_id = module.vpc.internet_gateway_id

  # FIX: These arguments pass the VPC Endpoint IDs (outputs from module.vpc) 
  # to the routing module so it can configure the route tables.
  vpce_s3_id              = module.vpc.vpce_s3_id
  vpce_dynamodb_id        = module.vpc.vpce_dynamodb_id
  vpce_ssm_id             = module.vpc.vpce_ssm_id
  vpce_ssmmessages_id     = module.vpc.vpce_ssmmessages_id
  vpce_ec2messages_id     = module.vpc.vpce_ec2messages_id
  vpce_secretsmanager_id  = module.vpc.vpce_secretsmanager_id

  vpce_kms_id = null
}