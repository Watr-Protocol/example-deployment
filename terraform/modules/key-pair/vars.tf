variable "name" {
  description = "The key pair name"
  type        = string
}
variable "ssh_public_key" {
  description = "The content of the SSH public key to add to the EC2 Key pair"
  type        = string
}

variable "tags" {
  description = "A list of tags"
  type        = map(string)
}
