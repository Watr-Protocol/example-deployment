resource "aws_vpc_endpoint_service" "endpoint_service" {
  count = length(var.allowed_principals) > 0 ? 1 : 0

  acceptance_required        = true
  network_load_balancer_arns = var.network_load_balancer_arns
  allowed_principals         = var.allowed_principals

  tags = merge(var.tags, {
    Name = var.name
  })
}
