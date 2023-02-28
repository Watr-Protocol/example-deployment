variable "private_route_table_ids" {
  description = "List of VPC route tables IDs"
  type        = list(string)
}

variable "cidr_block" {
  description = "VPC CIDR range"
  type        = string
}
variable "vpc_peering_connection_id" {
  description = "VPC Peering Connection ID"
  type        = string
}
