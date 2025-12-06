# /modules/nat/outputs.tf

output "nat_gateway_ids" {
  description = "Map of AZs to NAT Gateway IDs"
  value       = var.enable ? {
    for az, natgw in aws_nat_gateway.this : az => natgw.id
  } : {}
}
