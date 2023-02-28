variable "environment" {
  description = "The environment name"
  type        = string
}


variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
