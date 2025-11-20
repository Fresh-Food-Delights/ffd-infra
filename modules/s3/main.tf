   resource "aws_s3_bucket" "this" {
     bucket = var.bucket_name
     acl    = "private"

     tags = {
       Name        = var.bucket_name
       Environment = var.environment
     }
   }

   output "s3_bucket_id" {
     description = "The name/ID of the S3 bucket."
     value       = aws_s3_bucket.this.id
   }