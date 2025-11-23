# modules/s3/main.tf

provider "aws" {
  region = "us-east-1"  # or your chosen region
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}