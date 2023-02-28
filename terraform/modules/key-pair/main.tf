resource "aws_key_pair" "deployer" {
  key_name   = var.name
  public_key = var.ssh_public_key

  tags = var.tags
}
