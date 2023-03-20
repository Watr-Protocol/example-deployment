####################
# Common variables #
####################
variable "aws_region" {
  description = "The AWS region the project is in"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "terraform_state_bucket" {
  description = "The bucket which contains the Terraform state"
  type        = string
}

variable "cloudwatch_iam_profile" {
  description = "The cloudwatch IAM profile name"
  type        = string
}

variable "global_tags" {
  description = "The list of tags to attach to the bucket"
  type        = map(string)
}

####################
# Module variables #
####################
variable "availability_zones" {
  description = "List of the VPC availability zones"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
}

variable "vpc_peerings" {
  description = "Configuration of the VPC peerings to request"
  type        = map(object({ peer_account_id : string, peer_vpc_id : string, peer_vpc_cidr : string }))
}

variable "vpc_peerings_to_accept" {
  description = "Configuration of the VPC peerings to accept"
  type        = map(object({ peering_id : string, peer_vpc_cidr : string }))
}

variable "private_subnets" {
  description = "List of the private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of the public subnets"
  type        = list(string)
}

variable "ssh_ip_access_list" {
  description = "CIDR list of allowed IPs for SSH access"
  type        = list(string)
}

variable "monitoring_ip_access_list" {
  description = "CIDR list of allowed IPs for monitoring access"
  type        = list(string)
}

variable "public_dns_zone" {
  description = "The public DNS zone to use"
  type        = string
  default     = null
}

variable "private_dns_zone" {
  description = "The private DNS zone to use"
  type        = string
}

/*
variable "target_nodes" {
  description = "List of the public subnets"
  type = list(string)
}*/

variable "ec2_ssh_public_key" {
  description = "The content of the SSH public key to set up"
  type        = string
}

variable "enable_volume_snapshot_policy" {
  description = "Enable the AWS Lifecycle Manager policy for snapshotting the data disk volume"
  type        = bool
  default     = true
}

variable "initial_database_disk_snapshot_id" {
  description = "The id of the disk snapshot to use to initialize the data disk"
  type        = string
  default     = null
}

variable "bastions" {
  description = "Configuration of the bastions"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string }))
}

variable "monitoring" {
  description = "Configuration of the monitoring nodes"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string, volume_size_gb : number }))
}

variable "monitoring_database_enabled" {
  description = "Enable/disable the monitoring database"
  type        = bool
  default     = true
}
variable "monitoring_database" {
  description = "Configuration of the monitoring database"
  type        = object({ instance_class : optional(string), allocated_storage : optional(number), max_allocated_storage : optional(number) })
  default     = {}
}

variable "access_nodes" {
  description = "Configuration of the access nodes"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string, volume_size_gb : number, root_disk : number, provisioned_iops : number, initial_database_disk_snapshot_id : optional(string) }))
}

variable "validator_nodes" {
  description = "Configuration of the validator nodes"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string, volume_size_gb : number, root_disk : number, provisioned_iops : number, initial_database_disk_snapshot_id : optional(string) }))
}

variable "archive_nodes" {
  description = "Configuration of the archive nodes"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string, volume_size_gb : number, root_disk : number, provisioned_iops : number, initial_database_disk_snapshot_id : optional(string), enable_disk_snapshots : bool }))
}

variable "collator_nodes" {
  description = "Configuration of the index nodes"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string, volume_size_gb : number, root_disk : number, provisioned_iops : number, initial_database_disk_snapshot_id : optional(string) }))
}

variable "backup_nodes" {
  description = "Configuration of the backup nodes"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string, volume_size_gb : number, root_disk : number, provisioned_iops : number, initial_database_disk_snapshot_id : optional(string), enable_disk_snapshots : bool }))
}

variable "load_balancers" {
  description = "The load balancers configuration"
  type        = map(object({ static_targets : list(string), sticky_session : bool }))
}
