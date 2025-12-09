# /envs/prod/us-west-1/variables.tf

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = "771402395766"
}

variable "environment" {
  description = "Deployment environment for this stack"
  type        = string
  default     = "prod"
}

variable "region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-west-1"
}

variable "tier_edge" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "edge"
}

variable "tier_public" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "public"
}

variable "tier_private-web" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "private-web"
}

variable "tier_private-app" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "private-app"
}

variable "tier_private-db" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "private-db"
}

variable "tier_security" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "security"
}

variable "tier_iam" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "iam"
}

variable "tier_aws" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "aws"
}

variable "geo_restriction_countries" {
  description = "Allowed countries for CloudFront geo restriction"
  type        = list(string)
  default     = ["US"]
}

variable "ami_id_web" {
  description = "Map of region to AMI ID"
  type        = map(string)
  default = {
    "us-east-1" = "ami-0f00d706c4a80fd93"
    "us-west-1" = "ami-0e45116a579f0029a"
  }
}

variable "ami_id_app" {
  description = "Map of region to AMI ID"
  type        = map(string)
  default = {
    "us-east-1" = "ami-0f00d706c4a80fd93"
    "us-west-1" = "ami-0e45116a579f0029a"
  }
}

variable "user_data_base64" {
  description = "Base64-encoded user data for EC2 instances"
  type        = string
  default     = ""
}

variable "web_instance_type" {
  description = "Instance type for ASG EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "app_instance_type" {
  description = "Instance type for ASG EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "ec2_instance_type" {
  description = "Instance type for ASG EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_type" {
  description = "Instance type for ASG EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "enable_global_table" {
  description = "Toggle DynamoDB Global Table creation"
  type        = bool
  default     = false
}

variable "replica_regions" {
  type        = list(string)
  description = "DynamoDB global table replica regions"
  default     = []
}

variable "db_username" {
  type        = string
  description = "DB username for this environment"
  default     = "ffd-app-db-master"
}

variable "multi_az" {
  description = "Toggle multi-az creation"
  type        = bool
  default     = true
}

variable "is_replica" {
  description = "Toggle multi-az creation"
  type        = bool
  default     = true
}

variable "primary_instance_arn" {
  type        = string
  description = "ARN of primary RDS instance (from us-east-1)"
  default     = ""
}
#=================================================================#
variable "enable_edge" {
  description = "Toggle CloudFront + WAF"
  type        = bool
  default     = false
}

variable "enable_nat" {
  description = "Toggle NAT Gateway creation"
  type        = bool
  default     = false
}

variable "enable_alb_web" {
  description = "Toggle public web-facing ALB"
  type        = bool
  default     = false
}

variable "enable_alb_app" {
  description = "Toggle private app-facing ALB"
  type        = bool
  default     = false
}

variable "enable_ec2" {
  description = "Toggle EC2 instance (AMI builder)"
  type        = bool
  default     = false
}

variable "enable_ssm" {
  description = "Whether to enable SSM VPC endpoints"
  type        = bool
  default     = false
}

variable "enable_rds" {
  description = "Toggle RDS instance creation"
  type        = bool
  default     = false
}
#=================================================================#
