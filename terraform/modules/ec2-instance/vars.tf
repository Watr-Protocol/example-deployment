variable "environment" {
  description = "The environment name"
  type        = string
}

variable "name" {
  description = "The instance name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of VPC in which to create the security gropu"
  type        = string
}

variable "ami" {
  description = "The AMI to use to create the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}

variable "security_group_ids" {
  description = "The list of security group to attach to the instance"
  type        = list(string)
}

variable "key_pair" {
  description = "The key pair id to use for the instance"
  type        = string
}

variable "root_block_device" {
  description = "The root block device configuration for the disk"
  type        = list(map(string))
}

variable "subnet" {
  description = "The subnet in which to launch the instance ('public' or 'private')"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone in which to launch the instance"
  type        = string
}

variable "iam_instance_profile" {
  description = "Set an IAM profile on the instance"
  default     = ""
  type        = string
}

variable "data_disk_volume_size_gb" {
  description = "Set the data disk volume size (set to 0 to disable data disk creation)"
  type        = number
}

variable "data_disk_volume_provisioned_iops" {
  description = "The number of AWS volume provisioned IOPS for the instance data disk"
  type        = number
  default     = null
}

variable "enable_disk_snapshots" {
  description = "Mark the node data disk for snapshots"
  type        = bool
  default     = false
}

variable "initial_database_disk_snapshot_id" {
  description = "The volume snapshot ID to load"
  type        = string
  default     = null
}

variable "allocate_public_ip" {
  description = "Whether to allocate a public IP using AWS EIP"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
