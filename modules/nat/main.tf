# modules/nat/main.tf

resource "aws_eip" "this" {
  for_each = var.enable ? var.public_subnet_ids : {}
  domain   = "vpc"
  tags = {
    Name = "ffd-${var.environment}-nat-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each          = var.enable ? var.public_subnet_ids : {}
  allocation_id     = aws_eip.this[each.key].id
  subnet_id         = each.value
  connectivity_type = "public"

  tags = {
    Name = "ffd-${var.environment}-natgw-${each.key}"
  }

  depends_on = [aws_eip.this]
}
