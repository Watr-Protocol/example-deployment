// List subnets IDs from their names
data "aws_subnet_ids" "subnet_ids" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.environment}-${var.subnet}-${var.availability_zone}"
  }
}
