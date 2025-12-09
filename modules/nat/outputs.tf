# /modules/nat/outputs.tf

output "nat_gateway_ids" {
  description = "List of NAT gateway IDs for this environment"
  value       = var.enable ? [for gw in aws_nat_gateway.this : gw.id] : []
}
