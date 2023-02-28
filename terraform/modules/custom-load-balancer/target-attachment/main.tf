// Retrieve target instances IDs
data "aws_instances" "target-instances" {
  filter {
    name   = "tag:Name"
    values = formatlist("${var.environment}-%s", var.target_attachments)
  }
}

resource "aws_lb_target_group_attachment" "nodes_target_group_attachment" {
  for_each = toset(data.aws_instances.target-instances.ids)

  target_group_arn = var.target_group_arn
  port             = 8545
  target_id        = each.key
}
