// Create VPC peering connections
resource "aws_vpc_peering_connection" "vpc_peering" {
  for_each = var.vpc_peerings

  peer_owner_id = each.value.peer_account_id
  peer_vpc_id   = each.value.peer_vpc_id
  vpc_id        = var.vpc_id
  auto_accept   = true

  tags = merge(var.tags, {
    Name = "${var.environment}-peering-to-${each.key}"
  })
}

// Create a route table rule to route traffic to the peered VPC
module "peerings_route" {
  source = "./peering-route"

  for_each = var.vpc_peerings

  private_route_table_ids   = var.vpc_route_table_ids
  cidr_block                = each.value.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[each.key].id
}

// Connect to external VPC peering connections
resource "aws_vpc_peering_connection_accepter" "vpc_peering_accepter" {
  for_each = var.vpc_peerings_to_accept

  vpc_peering_connection_id = each.value.peering_id
  auto_accept               = true

  tags = merge(var.tags, {
    Name = "${var.environment}-peering-to-${each.key}"
  })
}

// Create a route table rule to route traffic to the peered VPC
module "peerings_to_accept_route" {
  source = "./peering-route"

  for_each = var.vpc_peerings_to_accept

  private_route_table_ids   = var.vpc_route_table_ids
  cidr_block                = each.value.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.vpc_peering_accepter[each.key].id
}
