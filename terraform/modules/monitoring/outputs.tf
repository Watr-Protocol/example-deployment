output "instances" {
  value = module.monitoring_instances
}

output "monitoring_private_ips" {
  value = [for instance in values(module.monitoring_instances) : instance.private_ip]
}

output "monitoring_security_group_id" {
  value = module.monitoring_security_group.security_group_id
}
