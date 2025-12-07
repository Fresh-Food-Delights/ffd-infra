# /modules/dynamodb/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  table_name = var.table_name != "" ? var.table_name : "ffd-sessions-${var.environment}"

  common_tags = {
    Environment = var.environment
    Service     = "ffd"
    Tier        = "app"
  }
}

resource "aws_dynamodb_table" "sessions" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "session_id"

  attribute {
    name = "session_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  global_secondary_index {
    name            = "gsi_user"
    hash_key        = "user_id"
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

  dynamic "replica" {
    for_each = var.enable_global_table ? var.replica_regions : []
    content {
      region_name = replica.value
    }
  }

  tags = local.common_tags
}
