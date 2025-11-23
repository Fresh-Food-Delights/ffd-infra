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
variable "policy" {
  description = "S3 bucket policy"
  type        = string
  default     = ""
}

variable "ownership_policy" {
  description = "Ownership policy for the S3 bucket"
  type        = string
  default     = ""
}

variable "public_block_policy" {
  description = "Public block policy for the S3 bucket"
  type        = string
  default     = ""
}

variable "sse_policy" {
  description = "SSE policy for the S3 bucket"
  type        = string
  default     = ""
}