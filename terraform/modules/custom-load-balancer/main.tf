// Create the load balancers
resource "aws_lb" "load_balancer" {
  for_each = var.load_balancers

  name               = "${var.environment}-${each.key}"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = merge(var.tags, { LoadBalancer : each.key })
}

resource "aws_lb_target_group" "nodes_target_group" {
  for_each = var.load_balancers

  name     = "${each.key}-nodes"
  port     = 9954
  protocol = "TCP"
  vpc_id   = var.vpc_id

  deregistration_delay = 90

  health_check {
    interval            = 10
    port                = 9954
    protocol            = "HTTP"
    path                = "/health"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
  }

  dynamic "stickiness" {
    for_each = each.value.sticky_session ? [1] : []
    content {
      enabled = true
      type    = "source_ip"
    }
  }

  tags = merge(var.tags, { LoadBalancer : each.key })
}

// Configure custom nodes load balancing to port 9954
resource "aws_lb_listener" "nodes_load_balancer_listener" {
  for_each = var.load_balancers

  load_balancer_arn = aws_lb.load_balancer[each.key].arn
  port              = 9954
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nodes_target_group[each.key].arn
  }
}

// Register instances on the Load Balancer target group
module "target_attachment" {
  source = "./target-attachment"

  for_each = var.load_balancers

  environment        = var.environment
  target_group_arn   = aws_lb_target_group.nodes_target_group[each.key].arn
  target_attachments = each.value.static_targets
}
