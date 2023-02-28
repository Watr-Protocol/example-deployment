variable "environment" {
  description = "The environment name"
  type        = string
}

variable "aws_region" {
  description = "The name of the aws_region"
  type        = string
}

variable "collator_nodes_iam_role_id" {
  description = "The ID of the IAM role attached to the index node instances"
  type        = string
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
