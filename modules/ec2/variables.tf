# modules/ec2/variables.tf

variable "name" {
  description = "Instance name suffix"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g. dev, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the instance"
  type        = string
  default     = "ami-12345678" # Dummy placeholder, never used if EC2/ASGs are disabled
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to assign to the EC2 instance"
  type        = list(string)
}

variable "associate_public_ip" {
  description = "Whether to assign a public IP (only valid for public subnet)"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "SSH key pair name for instance access"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags for the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "enable" {
  description = "Toggle creation of the EC2 instance"
  type        = bool
  default     = false
}
