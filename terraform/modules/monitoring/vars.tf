variable "name" {
  description = "The resource name"
  type        = string
}

variable "aws_region" {
  description = "The aws region name"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "monitoring" {
  description = "Configuration of the monitoring nodes"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string, volume_size_gb : number }))
}

variable "vpc_id" {
  description = "The ID of VPC in which to create the security gropu"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block"
  type        = string
}

variable "key_pair" {
  description = "The key pair id to use for the instance"
  type        = string
}

variable "public_dns_zone" {
  description = "The public DNS zone associated with this environment"
  type        = string
}

variable "public_dns_zone_id" {
  description = "The ID of the public DNS zone in which to create a record"
  type        = string
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone in which to create a record"
  type        = string
}

variable "bastion_ips" {
  description = "The list of bastion IPs that should be allowed to access the node from SSH"
  type        = list(string)
}

variable "monitoring_ip_access_list" {
  description = "CIDR list of allowed IPs for monitoring access"
  type        = list(string)
}

variable "ssh_ip_access_list" {
  description = "CIDR list of allowed IPs for monitoring access"
  type        = list(string)
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
