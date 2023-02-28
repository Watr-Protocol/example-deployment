resource "aws_route" "aws_peering_route" {
  for_each = toset(var.private_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = var.vpc_peering_connection_id
}
