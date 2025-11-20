   # modules/s3/variables.tf
   variable "bucket_name" {
     description = "The unique name for the S3 bucket."
     type        = string
   }

   variable "environment" {
     description = "The environment tag (e.g., dev, test)."
     type        = string
   }