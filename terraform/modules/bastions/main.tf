locals {

  // Define a Bastion security group following best practices in:
  // https://docs.aws.amazon.com/quickstart/latest/linux-bastion/architecture.html
  ingress_rules = concat(
    [for cidr in var.ssh_ip_access_list :
      {
        port        = 22
        protocol    = "tcp"
        description = "ssh"
        cidr_blocks = [cidr]
      }
    ],
    [{
      port        = 3142
      protocol    = "tcp"
      description = "internal apt proxy"
      cidr_blocks = [var.vpc_cidr]
      },
      {
        port        = 9100
        protocol    = "tcp"
        description = "node exporter"
        cidr_blocks = [var.vpc_cidr]
      },
      {
        port        = 9080
        protocol    = "tcp"
        description = "promtail"
        cidr_blocks = [var.vpc_cidr]
    }]
  )

  egress_rules = [
    {
      port        = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = [var.vpc_cidr]
    },
    {
      port        = 80
      protocol    = "tcp"
      description = "http"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      protocol    = "tcp"
      description = "https"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 3142
      protocol    = "tcp"
      description = "internal apt proxy"
      cidr_blocks = [var.vpc_cidr]
    },
    {
      port        = 3100
      protocol    = "tcp"
      description = "loki"
      cidr_blocks = [var.vpc_cidr]
    },
  ]
}

module "bastion_security_group" {
  source = "../security-group"

  name          = "${var.environment}-bastion-sg"
  description   = "security group for bastion hosts in ${var.environment}"
  vpc_id        = var.vpc_id
  ingress_rules = local.ingress_rules
  egress_rules  = local.egress_rules

  tags = var.tags
}

module "bastions_instances" {
  source = "../ec2-instance"

  for_each = var.bastions

  name              = "${var.environment}-${each.key}"
  environment       = var.environment
  instance_type     = each.value.instance_type
  ami               = each.value.ami
  subnet            = each.value.subnet
  availability_zone = each.value.availability_zone
  root_block_device = [{
    volume_type           = "standard"
    volume_size           = 16
    delete_on_termination = true
    encrypted             = true
  }]
  vpc_id                   = var.vpc_id
  key_pair                 = var.key_pair
  allocate_public_ip       = true
  data_disk_volume_size_gb = 0
  security_group_ids       = [module.bastion_security_group.security_group_id]

  tags = merge(var.tags, {
    InstanceType : "bastion"
  })
}

resource "aws_route53_record" "public_a_record" {
  for_each = module.bastions_instances

  zone_id = var.public_dns_zone_id
  name    = each.value.name
  type    = "A"
  ttl     = "1800"
  records = [each.value.public_ip]
}

resource "aws_route53_record" "private_a_record" {
  for_each = module.bastions_instances

  zone_id = var.private_dns_zone_id
  name    = each.value.name
  type    = "A"
  ttl     = "1800"
  records = [each.value.private_ip]
}
