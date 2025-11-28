# modules/dynamodb/main.tf

# 1. Define the core DynamoDB Table
resource "aws_dynamodb_table" "app_sessions" {
  name         = var.table_name
  billing_mode = "PROVISIONED"
  read_capacity = var.read_capacity
  write_capacity = var.write_capacity
  hash_key     = "SessionId"

  attribute {
    name = "SessionId"
    type = "S"  # String
  }

  # 2. Add TTL (Time-To-Live) for application sessions
  ttl {
    attribute_name = "ExpireTime"
    enabled        = true
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}

# Output the table name
output "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  value       = aws_dynamodb_table.app_sessions.name
}