variable "environment" {
  description = "The environment name (e.g., dev, prod)."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the endpoints will be created."
  type        = string
}

variable "private_web_subnet_ids" {
  description = "A list of private web subnet IDs, required for placing interface endpoints."
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "A list of private app subnet IDs, required for placing interface endpoints."
  type        = list(string)
}

variable "private_db_subnet_ids" {
  description = "A list of private db subnet IDs, required for placing interface endpoints."
  type        = list(string)
}

variable "vpc_endpoint_security_group_id" {
  description = "The ID of the Security Group to attach to the VPC Endpoints."
  type        = string
}