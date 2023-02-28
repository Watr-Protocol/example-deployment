variable "name" {
  description = "The VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "The VPC CIDR"
  type        = string
}

variable "availability_zones" {
  description = "The availability zone to use for the subnets of the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "The private subnet CIDRs of this VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "The public subnet CIDRs of this VPC"
  type        = list(string)
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}

