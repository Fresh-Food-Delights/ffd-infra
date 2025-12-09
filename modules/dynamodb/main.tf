# /modules/dynamodb/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

locals {
  table_name = var.table_name != "" ? var.table_name : "ffd-sessions-${var.environment}"
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
  lifecycle {
    ignore_changes = [
      stream_enabled,
      stream_view_type,
    ]
  }
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
  }
}
