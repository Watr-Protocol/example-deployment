resource "aws_route53_zone" "public_dns_zone" {
  name          = var.public_dns_zone
  comment       = "${var.environment} public dns zone"
  force_destroy = true

  tags = var.tags
}

resource "aws_route53_zone" "private_dns_zone" {
  name = var.private_dns_zone
  vpc {
    vpc_id = var.vpc_id
  }
  comment       = "${var.environment} private dns zone"
  force_destroy = true

  tags = var.tags
}


