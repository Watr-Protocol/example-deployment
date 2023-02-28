resource "aws_security_group" "security_group" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules

    content {
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol
      description = egress.value.description
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge({ Name : var.name }, var.tags)
}

