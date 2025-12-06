# /modules/security/variables.tf

variable "name" {
  type        = string
  description = "Name identifier for the security group"
}

variable "description" {
  type        = string
  description = "Description of the security group"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created"
}

variable "ingress_rules" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    description     = optional(string)
  }))
  default = []
}

variable "egress_rules" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    description     = optional(string)
  }))
  default = []
}
