resource "local_file" "ssh_config" {
  filename        = var.filepath
  file_permission = "0644"
  content = format("%s",
    join("\n",
      // Bastion SSH Config
      formatlist("Host %s\n  ForwardAgent yes\n  HostName %s\n",
        [for host in var.bastions : "${var.environment}-bastion-${host.availability_zone}"],
        [for host in var.bastions : host.public_ip]
      ),
      // Nodes SSH Config
      formatlist("Host %s\n  ProxyJump ${var.environment}-bastion-%s\n  HostName %s\n",
        [for host in
          merge(
            var.access_nodes,
            var.validator_nodes,
            var.archive_nodes,
            var.collator_nodes,
            var.backup_nodes,
            var.monitoring,
          ) :
          host.name
        ],
        [for host in
          merge(
            var.access_nodes,
            var.validator_nodes,
            var.archive_nodes,
            var.collator_nodes,
            var.backup_nodes,
            var.monitoring,
          ) :
          host.availability_zone
        ],
        [for host in
          merge(
            var.access_nodes,
            var.validator_nodes,
            var.archive_nodes,
            var.collator_nodes,
            var.backup_nodes,
            var.monitoring,
          ) :
          host.private_ip
        ]
      )
    )
  )
}
