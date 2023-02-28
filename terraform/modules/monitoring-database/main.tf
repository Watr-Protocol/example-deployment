resource "aws_db_subnet_group" "monitoring_subnet_group" {
  name       = "${var.environment}-database-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "monitoring-db-subnet-group"
  }
}

resource "random_string" "database_password" {
  length  = 20
  special = false
}

module "monitoring_database_security_group" {
  source = "../security-group"

  name        = "${var.environment}-monitoring-database-sg"
  description = "monitoring database security group in ${var.environment}"
  vpc_id      = var.vpc_id
  ingress_rules = [{
    port        = 5432
    protocol    = "tcp"
    description = "monitoring instance access"
    cidr_blocks = [for ip in var.blockscout_instance_ips : "${ip}/32"]
  }]
  egress_rules = []

  tags = var.tags
}

resource "aws_db_instance" "monitoring_database" {
  count = var.enabled ? 1 : 0

  identifier             = "${var.environment}-monitoring-db"
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "12"
  instance_class         = var.database_instance_class
  vpc_security_group_ids = [module.monitoring_database_security_group.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.monitoring_subnet_group.name
  maintenance_window     = "Sun:00:00-Sun:03:00"
  copy_tags_to_snapshot  = true
  skip_final_snapshot    = true

  username = "monitoring"
  password = random_string.database_password.result

  tags = merge(var.tags, { Name : "${var.environment}-monitoring-db" })
}
