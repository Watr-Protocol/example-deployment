output "instances" {
  value = module.bastions_instances
}

output "bastion_private_ips" {
  value = [for bastion in values(module.bastions_instances) : bastion.private_ip]
}
