# modules/asg-app/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for launch template"
  default     = "ami-12345678" # Dummy placeholder, never used if EC2/ASGs are disabled
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups to associate with instances"
}

variable "user_data_base64" {
  type        = string
  description = "Base64-encoded user data"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the ASG"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of EC2 instances"
}

variable "min_size" {
  type        = number
  description = "Minimum number of EC2 instances"
}

variable "max_size" {
  type        = number
  description = "Maximum number of EC2 instances"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the target group for ALB"
}
