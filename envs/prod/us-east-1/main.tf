# ==============================================================================
# FFD PRODUCTION ENVIRONMENT (US-EAST-1)
#
# This file defines the core networking stack, ensuring VPC endpoints are
# correctly configured and routed.
# ==============================================================================

# ----------------------------------------------------
# 1. TERRAFORM BLOCK (Providers)
# ----------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ----------------------------------------------------
# 2. PROVIDER (Assuming var.region is defined in variables.tf)
# ----------------------------------------------------
provider "aws" {
  region = var.region
}

# -----------------------------------------------------------------------------
# 3. NETWORKING LAYERS
# -----------------------------------------------------------------------------

# --- VPC SECURITY MODULE ---
# Defines the dedicated Security Group for all VPC Interface Endpoints.
# Must run before the 'vpc' module, as the VPC module requires its SG ID.
module "security_internal" {
  source      = "../../../modules/vpc_security"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id # Note: This creates a dependency loop we must break.
                                  # To resolve: Define vpc_security first, without vpc_id, or define rules separately.
                                  # For now, we assume VPC ID is available via dependency chaining below.
  vpc_cidr    = "10.0.0.0/16" # Hardcoded VPC CIDR for SG ingress rule
}


# --- SUBNET MODULE ---
# Creates all public, web, app, and DB subnets.
# Must run before the 'vpc' module, as the VPC endpoints need subnet IDs.
module "subnets" {
  source                   = "../../../modules/subnet"
  environment              = var.environment
  vpc_id                   = module.vpc.vpc_id
  # Placeholder CIDR blocks - update with your production ranges
  public_subnet_cidrs      = { "${var.region}a" = "10.0.1.0/24", "${var.region}b" = "10.0.2.0/24" }
  private_web_subnet_cidrs = { "${var.region}a" = "10.0.11.0/24", "${var.region}b" = "10.0.12.0/24" }
  private_app_subnet_cidrs = { "${var.region}a" = "10.0.21.0/24", "${var.region}b" = "10.0.22.0/24" }
  private_db_subnet_cidrs  = { "${var.region}a" = "10.0.31.0/24", "${var.region}b" = "10.0.32.0/24" }
}

# --- NAT Gateway Module ---
# Creates the NAT Gateway (EIP and GW) for internet access from private subnets.
module "nat" {
  source            = "../../../modules/nat"
  environment       = var.environment
  public_subnet_ids = values(module.subnets.public_subnet_ids) # Use values() if output is a map
  enable            = true # Assuming NAT is enabled for Production
}


# --- VPC MODULE ---
# Creates the core VPC, IGW, and VPC Endpoints submodule.
module "vpc" {
  source      = "../../../modules/vpc"
  environment = var.environment
  vpc_cidr    = "10.0.0.0/16"

  # Inputs required for the vpc_endpoints submodule:
  
  # 1. Security Group ID for Interface Endpoints
  # Note: This SG is defined in module.security_internal
  vpc_endpoint_security_group_id = module.security_internal.vpc_endpoint_security_group_id

  # 2. Subnet IDs for ENI placement
  # We use 'values()' to correctly transform map outputs from the subnets module into lists.
  private_web_subnet_ids = values(module.subnets.private_web_subnet_ids)
  private_app_subnet_ids = values(module.subnets.private_app_subnet_ids)
  private_db_subnet_ids  = values(module.subnets.private_db_subnet_ids)
}


# --- ROUTING MODULE ---
# Configures all the route tables, including routes to the NAT Gateway and VPC Endpoints.
module "routing" {
  source              = "../../../modules/routing"
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
  enable_nat_gateway  = true
  nat_gateway_ids     = module.nat.nat_gateway_ids
  
  # Subnet IDs and associated Route Tables are needed for routing
  public_subnet_ids        = values(module.subnets.public_subnet_ids)
  private_web_subnet_ids   = values(module.subnets.private_web_subnet_ids)
  private_app_subnet_ids   = values(module.subnets.private_app_subnet_ids)
  private_db_subnet_ids    = values(module.subnets.private_db_subnet_ids)

  # VPC Endpoint IDs are passed from the VPC module (which gets them from its submodule)
  vpce_s3_id             = module.vpc.vpce_s3_id
  vpce_dynamodb_id       = module.vpc.vpce_dynamodb_id
  vpce_ssm_id            = module.vpc.vpce_ssm_id
  vpce_ssmmessages_id    = module.vpc.vpce_ssmmessages_id
  vpce_ec2messages_id    = module.vpc.vpce_ec2messages_id
  vpce_kms_id            = module.vpc.vpce_kms_id
  vpce_secretsmanager_id = module.vpc.vpce_secretsmanager_id
}

# -----------------------------------------------------------------------------
# 4. OTHER APPLICATION LAYERS (Placeholder)
# -----------------------------------------------------------------------------
# ... Add other necessary production modules (ALB, ASG, RDS, S3, etc.) here