variable "environment" {
  description = "The environment name"
  type        = string
}

variable "validator_nodes" {
  description = "Configuration of the validator nodes"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string, volume_size_gb : number, provisioned_iops : number, initial_database_disk_snapshot_id : optional(string) }))
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}
variable "vpc_cidr" {
  description = "The VPC CIDR block"
  type        = string
}

variable "common_security_group_ids" {
  description = "The list of shared security groups to attach to the instance"
  type        = list(string)
}

variable "public_dns_zone_id" {
  description = "The ID of the public DNS zone in which to create a record"
  type        = string
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone in which to create a record"
  type        = string
}

variable "key_pair" {
  default = "The key pair ID"
  type    = string
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}

variable "iam_instance_profile" {
  type = string
}

variable "ssh_ip_access_list" {
  description = "CIDR list of allowed IPs for SSH access"
  type        = list(string)
}

variable "root_disk" {
   description = "root disk size"
   type        = string
   default     = "400"
}
