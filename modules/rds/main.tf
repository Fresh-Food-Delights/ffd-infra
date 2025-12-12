# /modules/rds/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_db_subnet_group" "this" {
  count      = var.enable && !var.is_replica ? 1 : 0
  name       = "ffd-${var.environment}-db-subnets"
  subnet_ids = var.db_subnet_ids
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
  }
}

resource "aws_db_instance" "primary" {
  count = var.enable && !var.is_replica ? 1 : 0
  identifier_prefix = "ffd-${var.environment}-postgres"
  engine            = "postgres"
  engine_version    = "18.1"
  instance_class    = var.db_instance_type
  allocated_storage = 20
  storage_type      = "gp3"
  db_name  = "ffd_app_db"
  username = "${var.db_username}_${var.environment}"
  manage_master_user_password = true
  multi_az                 = var.multi_az
  storage_encrypted        = true
  publicly_accessible      = false
  skip_final_snapshot      = true
  deletion_protection      = false
  apply_immediately        = true
  backup_retention_period  = 7
  delete_automated_backups = true
  vpc_security_group_ids = var.db_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.this[0].name
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
  }
}

resource "aws_db_instance" "replica" {
  count = var.enable && var.is_replica ? 1 : 0
  engine               = "postgres"
  instance_class       = var.db_instance_type
  replicate_source_db  = var.primary_instance_arn
  publicly_accessible  = false
  storage_encrypted    = true
  apply_immediately    = true
  deletion_protection  = false
  skip_final_snapshot  = true
  vpc_security_group_ids = var.db_security_group_ids
  db_subnet_group_name   = null
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
    Role        = "read-replica"
  }
}
