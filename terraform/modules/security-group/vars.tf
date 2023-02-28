variable "name" {
  description = "The security group name"
  type        = string
}

variable "description" {
  description = "The security group description"
  type        = string
}

variable "vpc_id" {
  description = "The ID of VPC in which to create the security gropu"
  type        = string
}

variable "ingress_rules" {
  description = "A list of ingress (inbound) rules"
  type        = list(object({ port : number, protocol : string, description : string, cidr_blocks : list(string) }))
}

variable "egress_rules" {
  description = "A list of egress (outbound) rules"
  type        = list(object({ port : number, protocol : string, description : string, cidr_blocks : list(string) }))
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
