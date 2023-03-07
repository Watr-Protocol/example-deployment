locals {
  // Open SSH connection from Bastions
  ingress_bastion_rules = [for bastion_ip in var.bastion_ips : {
    port        = 22
    protocol    = "tcp"
    description = "ssh"
    cidr_blocks = ["${bastion_ip}/32"]
  }]

  // Open scraping metrics and logs endpoints from the Monitoring servers
  ingress_monitoring_rules = flatten(
    [for monitoring_ip in var.monitoring_ips :
      [{
        port        = 9615
        protocol    = "tcp"
        description = "polkadot exporter"
        cidr_blocks = ["${monitoring_ip}/32"]
        },
        {
          port        = 9100
          protocol    = "tcp"
          description = "prometheus node exporter"
          cidr_blocks = ["${monitoring_ip}/32"]
        },
        {
          port        = 9080
          protocol    = "tcp"
          description = "promtail"
          cidr_blocks = ["${monitoring_ip}/32"]
        },
        {
          port        = 22
          protocol    = "tcp"
          description = "ssh"
          cidr_blocks = ["${ssh_ip_access_list}"]
        }
      ]
  ])

  // Open ports required by a collator
  ingress_generic_rules = [
    {
      port        = 30333
      protocol    = "tcp"
      description = "p2p"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 123
      protocol    = "udp"
      description = "ntp (tcp)"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 5353
      protocol    = "udp"
      description = "mdns"
      cidr_blocks = [var.vpc_cidr_block]
    },
   {
          port        = 22
          protocol    = "tcp"
          description = "ssh"
          cidr_blocks = ["${ssh_ip_access_list}"]
        }

  ]

  // Add rules to allow traffic to peered VPCs collator nodes
  peering_vpc_rules = concat(
    [for peering in var.vpc_peerings :
      {
        port        = 30343
        protocol    = "tcp"
        description = "p2p"
        cidr_blocks = [peering.peer_vpc_cidr]
      }
    ],
    [for peering in var.vpc_peerings_to_accept :
      {
        port        = 30343
        protocol    = "tcp"
        description = "p2p 30343"
        cidr_blocks = [peering.peer_vpc_cidr]
      }
    ]
  )

  ingress_rules = concat(
    local.ingress_bastion_rules,
    local.ingress_monitoring_rules,
    local.ingress_generic_rules,
    local.peering_vpc_rules
  )

  egress_rules = concat([
    {
      port        = 53
      protocol    = "udp"
      description = "internal dns udp"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 53
      protocol    = "tcp"
      description = "internal dns tcp"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 123
      protocol    = "tcp"
      description = "internal tcp ntp"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 5353
      protocol    = "udp"
      description = "internal udp mdns"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 30333
      protocol    = "tcp"
      description = "internal p2p"
      cidr_blocks = ["0.0.0.0/0"]
    },
    // Open outbound traffic to the apt proxy server
    {
      port        = 0
      protocol    = "-1"
      description = "open all"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      protocol    = "tcp"
      description = "open all"
      cidr_blocks = ["0.0.0.0/0"]
    },

    {
      port        = 3142
      protocol    = "tcp"
      description = "internal apt proxy"
      cidr_blocks = [var.vpc_cidr_block]
    },
    {
      port        = 3100
      protocol    = "tcp"
      description = "loki"
      cidr_blocks = [var.vpc_cidr_block]
    },
    ],
  local.peering_vpc_rules)
}

module "common_nodes_security_group" {
  source = "../../security-group"

  name        = var.name
  description = "common security group for nodes"
  vpc_id      = var.vpc_id

  ingress_rules = local.ingress_rules
  egress_rules  = local.egress_rules

  tags = var.tags
}
