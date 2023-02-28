variable "environment" {
  description = "The environment name"
  type        = string
}

variable "aws_region" {
  description = "The name of the aws_region"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the current VPC"
  type        = string
}

variable "enabled" {
  description = "Enable/disable the monitoring database"
  type        = bool
}

variable "allocated_storage" {
  description = "The database allocated storage"
  type        = number
}

variable "max_allocated_storage" {
  description = "The database maximum allocated storage"
  type        = number
}

variable "database_instance_class" {
  description = "The AWS database instance class for the monitoring database"
  type        = string
}

variable "private_subnet_ids" {
  description = "The list of private subnet IDs in the VPC"
  type        = list(string)
}

variable "blockscout_instance_ips" {
  description = "The list of IPs corresponding the instances that host blockscout"
  type        = list(string)
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}

