variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "vpc_peerings" {
  description = "Configuration of the VPC peerings nodes"
  type        = map(object({ peer_account_id : string, peer_vpc_id : string, peer_vpc_cidr : string }))
}

variable "vpc_peerings_to_accept" {
  description = "List of VPC peering to accept"
  type        = map(object({ peering_id : string, peer_vpc_cidr : string }))
}

variable "vpc_route_table_ids" {
  description = "List of VPC route tables IDs"
  type        = list(string)
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
