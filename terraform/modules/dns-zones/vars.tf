variable "environment" {
  description = "The environment"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to set for the private zone"
  type        = string
}

variable "public_dns_zone" {
  description = "The public zone domain name"
  type        = string
}

variable "private_dns_zone" {
  description = "The private zone domain name"
  type        = string
}

variable "tags" {
  description = "The list of tags to attach to the bucket"
  type        = map(string)
}
