variable "target_attachments" {
  description = "A list of instance names to attach to the load balancer target group"
  type        = list(string)
}

variable "target_group_arn" {
  description = "The load balancer target group arn"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}
