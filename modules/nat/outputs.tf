# modules/nat/outputs.tf

output "nat_gateway_ids" {
  description = "Map of AZs to NAT Gateway IDs"
  value = {
    for az, natgw in aws_nat_gateway.this :
    az => natgw.id
  }
}
