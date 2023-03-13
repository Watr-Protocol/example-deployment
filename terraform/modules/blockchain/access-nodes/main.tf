module "access_nodes_security_group" {
  source = "../../security-group"

  name        = "${var.environment}-access-nodes-sg"
  description = "security group for access nodes in ${var.environment}"
  vpc_id      = var.vpc_id
  ingress_rules = [
    // Allow traffic from the Load Balancer to the RPC endpoint
    {
      port        = 80
      protocol    = "tcp"
      description = "web (tcp)"
      cidr_blocks = ["0.0.0.0/0"]
    },
    // Allow traffic from the Load Balancer to the Health-check endpoint
    {
      port        = 443
      protocol    = "tcp"
      description = "https (tcp)"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = []

  tags = var.tags
}

module "access_nodes" {
  source = "../../ec2-instance"

  for_each = var.access_nodes

  name              = "${var.environment}-${each.key}"
  environment       = var.environment
  instance_type     = each.value.instance_type
  ami               = each.value.ami
  subnet            = each.value.subnet
  availability_zone = each.value.availability_zone
  root_block_device = [{
    volume_type           = "gp2"
    volume_size           = 250
    delete_on_termination = true
    encrypted             = true
  }]
  data_disk_volume_size_gb          = each.value.volume_size_gb
  data_disk_volume_provisioned_iops = each.value.provisioned_iops
  vpc_id                            = var.vpc_id
  security_group_ids                = concat(var.common_security_group_ids, [module.access_nodes_security_group.security_group_id])
  key_pair                          = var.key_pair
  initial_database_disk_snapshot_id = each.value.initial_database_disk_snapshot_id
  iam_instance_profile              = var.iam_instance_profile


  tags = merge(var.tags, {
    BlockchainNodeType : "access-node"
    InstanceType : "blockchain"
  })
}

resource "aws_route53_record" "private_a_record" {
  for_each = module.access_nodes

  zone_id = var.private_dns_zone_id
  name    = each.value.name
  type    = "A"
  ttl     = "1800"
  records = [each.value.private_ip]
}
