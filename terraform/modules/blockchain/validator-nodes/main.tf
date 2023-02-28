module "validator_nodes_security_group" {
  source = "../../security-group"

  name          = "${var.environment}-validator-nodes-sg"
  description   = "security group for validator nodes in ${var.environment}"
  vpc_id        = var.vpc_id
  ingress_rules = []
  egress_rules  = []

  tags = var.tags
}

module "validator_nodes" {
  source = "../../ec2-instance"

  for_each = var.validator_nodes

  name              = "${var.environment}-${each.key}"
  environment       = var.environment
  instance_type     = each.value.instance_type
  ami               = each.value.ami
  subnet            = each.value.subnet
  availability_zone = each.value.availability_zone
  root_block_device = [{
    volume_type           = "gp2"
    volume_size           = 16
    delete_on_termination = true
    encrypted             = true
  }]
  data_disk_volume_size_gb          = each.value.volume_size_gb
  data_disk_volume_provisioned_iops = each.value.provisioned_iops
  vpc_id                            = var.vpc_id
  security_group_ids                = concat(var.common_security_group_ids, [module.validator_nodes_security_group.security_group_id])
  key_pair                          = var.key_pair
  initial_database_disk_snapshot_id = each.value.initial_database_disk_snapshot_id

  tags = merge(var.tags, {
    InstanceType : "blockchain"
    BlockchainNodeType : "validator-node"
  })
}

resource "aws_route53_record" "private_a_record" {
  for_each = module.validator_nodes

  zone_id = var.private_dns_zone_id
  name    = each.value.name
  type    = "A"
  ttl     = "1800"
  records = [each.value.private_ip]
}
