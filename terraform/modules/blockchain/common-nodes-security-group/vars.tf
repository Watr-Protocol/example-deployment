variable "name" {
  description = "The security group name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of VPC in which to create the security gropu"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block"
  type        = string
}

variable "bastion_ips" {
  description = "The list of bastion IPs that should be allowed to access the node from SSH"
  type        = list(string)
}

variable "monitoring_ips" {
  description = "The monitoring machine IPs"
  type        = list(string)
}

variable "vpc_peerings" {
  description = "Configuration of the requested VPC peerings to request"
  type        = map(object({ peer_account_id : string, peer_vpc_id : string, peer_vpc_cidr : string }))
}

variable "vpc_peerings_to_accept" {
  description = "Configuration of the VPC peerings to accept"
  type        = map(object({ peering_id : string, peer_vpc_cidr : string }))
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
