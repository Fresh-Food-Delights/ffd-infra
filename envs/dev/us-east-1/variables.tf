# envs/dev/us-east-1/variables.tf

variable "region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment for this stack"
  type        = string
  default     = "dev"
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

variable "user_data_base64" {
  description = "Base64-encoded user data for EC2 instances"
  type        = string
  default     = ""
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
