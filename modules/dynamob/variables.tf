# modules/dynamodb/variables.tf

variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
}

variable "environment" {
  description = "The environment tag (e.g., dev, test)."
  type        = string
}

variable "read_capacity" {
  description = "The read capacity units for the table."
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "The write capacity units for the table."
  type        = number
  default     = 5
}