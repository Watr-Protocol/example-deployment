variable "environment" {
  description = "The environment name"
  type        = string
}

variable "bastions" {
  description = "Configuration of the bastions"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string }))
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}
variable "vpc_cidr" {
  description = "The VPC CIDR block"
  type        = string
}

variable "ssh_ip_access_list" {
  description = "CIDR list of allowed IPs for SSH access"
  type        = list(string)
}

variable "key_pair" {
  description = "The key pair ID"
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

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}

variable "iam_instance_profile" {
  type = string
}