variable "name" {
  description = "The load balancer name"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "The list of private subnet IDs"
  type        = list(string)
}

variable "load_balancers" {
  description = "The load balancers configuration"
  type        = map(object({ static_targets : list(string), sticky_session : bool }))
}

variable "public_dns_zone" {
  description = "The public DNS zone to use"
  type        = string
}

variable "public_dns_zone_id" {
  description = "The public DNS zone ID"
  type        = string
}


variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
