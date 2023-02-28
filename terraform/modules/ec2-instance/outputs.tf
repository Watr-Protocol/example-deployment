output "name" {
  value = var.name
}

output "availability_zone" {
  value = aws_instance.ec2_instance.availability_zone
}

output "subnet" {
  value = aws_instance.ec2_instance.subnet_id
}

output "private_ip" {
  value = aws_network_interface.default_network_interface.private_ip
}

output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

output "instance_id" {
  value = aws_instance.ec2_instance.id
}

