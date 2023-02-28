module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = var.name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = var.tags
}
