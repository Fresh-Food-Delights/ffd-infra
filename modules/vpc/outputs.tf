# modules/vpc/outputs.tf

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
  description = "The ID of the Internet Gateway"
}
