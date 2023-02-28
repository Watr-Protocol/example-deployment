output "endpoint" {
  value = var.enabled ? aws_db_instance.monitoring_database[0].endpoint : ""
}

output "username" {
  value = var.enabled ? aws_db_instance.monitoring_database[0].username : ""
}

output "password" {
  value = var.enabled ? aws_db_instance.monitoring_database[0].password : ""
}
