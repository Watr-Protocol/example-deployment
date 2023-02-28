locals {
  bastion_ip_ingress_rules = [for bastion_ip in var.bastion_ips : {
    port        = 22
    protocol    = "tcp"
    description = "ssh"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  # hack fixme
  monitoring_ip_access_list_rules = [
    {
      port        = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = ["212.227.197.206/32"]
    }
  ]
  ingress_rules = concat(
    local.bastion_ip_ingress_rules,
    local.monitoring_ip_access_list_rules,
    [
      {
        port        = 3100
        protocol    = "tcp"
        description = "${var.name} loki access"
        cidr_blocks = ["10.0.0.0/8"]
      },
    {
      port        = 443
      protocol    = "tcp"
      description = "https"
      cidr_blocks = ["212.227.197.206/32","173.54.188.59/32","2.218.70.204/32"] # parity vpn / corey / niall
    }
    ]
  )

  egress_rules = [
    {
      port        = 9615
      protocol    = "tcp"
      description = "polkadot exporter port"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 9625
      protocol    = "tcp"
      description = "polkadot exporter port"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 9100
      protocol    = "tcp"
      description = "prometheus-node-exporter port"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 9080
      protocol    = "tcp"
      description = "promtail port"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 587
      protocol    = "tcp"
      description = "smtp port"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 0
      protocol    = "tcp"
      description = "all ports"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port     =  80
      protocol    = "tcp"
      description = "http"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port     =  443
      protocol    = "tcp"
      description = "https"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "monitoring_security_group" {
  source = "../security-group"

  name          = "${var.name}-sg"
  description   = "monitoring servers security group in ${var.name}"
  vpc_id        = var.vpc_id
  ingress_rules = local.ingress_rules
  egress_rules  = local.egress_rules

  tags = var.tags
}

resource "aws_iam_instance_profile" "prometheus_iam_instance_profile" {
  name = var.name
  role = aws_iam_role.prometheus_iam_role.name
}

resource "aws_iam_role" "prometheus_iam_role" {
  name = var.name

  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_list_read_tags" {
  name = "${var.name}-ec2-list-read-tags"
  role = aws_iam_role.prometheus_iam_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "prometheus_cloudwatch_exporter_role_policy" {
  name = "${var.name}-cloudwatch-exporter"
  role = aws_iam_role.prometheus_iam_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "tag:GetResources",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "monitoring_route53_updates" {
  name = "${var.name}-route53-updates"
  role = aws_iam_role.prometheus_iam_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "route53:GetChange",
          "route53:ChangeResourceRecordSets"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:route53:::change/*",
          "arn:aws:route53:::hostedzone/${var.public_dns_zone_id}"
        ]
      },
      {
        "Action": "route53:ListResourceRecordSets",
        "Effect": "Allow",
        "Resource": "arn:aws:route53:::hostedzone/${var.public_dns_zone_id}"
      },
      {
        "Action": "route53:ListHostedZones",
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

module "monitoring_instances" {
  source = "../ec2-instance"

  for_each = var.monitoring

  name              = "${var.environment}-${each.key}"
  environment       = var.environment
  instance_type     = each.value.instance_type
  ami               = each.value.ami
  subnet            = each.value.subnet
  availability_zone = each.value.availability_zone
  root_block_device = [{
    volume_type           = "gp2"
    volume_size           = each.value.volume_size_gb
    delete_on_termination = true
    encrypted             = true
  }]
  vpc_id                   = var.vpc_id
  security_group_ids       = [module.monitoring_security_group.security_group_id]
  iam_instance_profile     = aws_iam_instance_profile.prometheus_iam_instance_profile.name
  key_pair                 = var.key_pair
  allocate_public_ip       = true
  data_disk_volume_size_gb = 0

  tags = merge(var.tags, {
    InstanceType : "monitoring"
  })
}

resource "aws_route53_record" "monitoring_a_record" {
  count = length(var.monitoring) > 0 ? 1 : 0

  zone_id = var.public_dns_zone_id
  name    = "monitoring"
  type    = "A"
  ttl     = "1800"
  records = flatten([for instance in keys(module.monitoring_instances) : module.monitoring_instances[instance].public_ip])
}

resource "aws_route53_record" "rpc_a_record" {
  count = length(var.monitoring) > 0 ? 1 : 0

  zone_id = var.public_dns_zone_id
  name    = "rpc"
  type    = "A"
  ttl     = "1800"
  records = flatten([for instance in keys(module.monitoring_instances) : module.monitoring_instances[instance].public_ip])
}

resource "aws_route53_record" "private_a_record" {
  for_each = module.monitoring_instances

  zone_id = var.private_dns_zone_id
  name    = each.value.name
  type    = "A"
  ttl     = "1800"
  records = [each.value.private_ip]
}
