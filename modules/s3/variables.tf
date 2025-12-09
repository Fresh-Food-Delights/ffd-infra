# /modules/s3/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
  default = "dev"
}

variable "region" {
  description = "AWS region (e.g., us-east-1)"
  type        = string
  default = "us-east-1"
}

variable "tier" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "aws"
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
}

variable "account_id" {
  type        = string
  description = "AWS account ID used in bucket policy"
}

variable "object_ownership" {
  description = "Ownership setting for the bucket"
  type        = string
  default     = "BucketOwnerPreferred"
}

variable "sse_algorithm" {
  description = "Default SSE algorithm (AES256 for SSE-S3 or aws:kms)"
  type        = string
  default     = "AES256"
}
