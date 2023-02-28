variable "name" {
  description = "The resource name"
  type        = string
}

variable "network_load_balancer_arns" {
  description = "A list of Network Load Balancer arns for the endpoint service"
  type        = list(string)
}

variable "allowed_principals" {
  description = "A list of allowed AWS principals for the endpoint service"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
