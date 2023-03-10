variable "cloudwatch" {
  description = "Configuration of the cloudwatch nodes"
  type        = map(object({ ami : string, instance_type : string, subnet : string, availability_zone : string, volume_size_gb : number }))
}
