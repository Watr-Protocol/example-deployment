output "public_zone_id" {
  value = aws_route53_zone.public_dns_zone.zone_id
}

output "private_zone_id" {
  value = aws_route53_zone.private_dns_zone.zone_id
}
