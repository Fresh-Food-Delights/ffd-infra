# modules/s3/variables.tf

variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "The environment tag (e.g., dev, test)."
  type        = string
}

variable "bucket_name" {
  description = "The unique name for the S3 bucket."
  type        = string
}