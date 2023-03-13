output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}


output "monitoring" {
  value = [for instance in module.monitoring.instances : {
    name : instance.name
    availability-zone : instance.availability_zone
    private_ip : instance.private_ip
    public_ip : instance.public_ip
  }]
}

output "monitoring_database" {
  value = var.monitoring_database_enabled ? {
    endpoint : module.monitoring-database.endpoint
    username : module.monitoring-database.username
    password : nonsensitive(module.monitoring-database.password)
  } : {}
}

output "bastions" {
  value = [for bastion in module.bastions.instances : {
    name : bastion.name
    availability-zone : bastion.availability_zone
    private_ip : bastion.private_ip
    public_ip : bastion.public_ip
  }]
}

output "blockchain_nodes" {
  value = [for node in merge(
    module.access_nodes.instances,
    module.validator_nodes.instances,
    module.archive_nodes.instances,
    module.collator_nodes.instances,
    module.backup_nodes.instances,
    ) : {
    name : node.name
    availability-zone : node.availability_zone
    private_ip : node.private_ip
    public_ip : node.public_ip
  }]
}

output "load_balancers" {
  value = module.custom_load_balancer
}

output "cloudwatch" {
  value = module.cloudwatch
}
