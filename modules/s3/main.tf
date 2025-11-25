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

data "aws_iam_policy_document" "combined_policy" {
  
  # 1. Deny Insecure Transport (SSL only)
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    # This dynamically grabs the ARN of whatever bucket is being created
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  # 2. Limit to Your Account ID (771402395766)
  statement {
    sid     = "LimitToAccount"
    effect  = "Deny"
    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalAccount"
      values   = ["771402395766"] 
    }
  }
}

# 3. Attach the policy to the bucket
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.combined_policy.json
}