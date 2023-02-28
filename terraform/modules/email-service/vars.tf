variable "environment" {
  description = "The environment name"
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

variable "aws_region" {
  description = "The name of the aws_region"
  type        = string
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}

