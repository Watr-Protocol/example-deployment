resource "random_string" "this" {
  length  = 4
  special = false
}

module "cloudwatch" {
  source      = "../cloudwatch"
  // Workaround with ${random_string.this.result}() to avoid name collision
  role_name   = "cloudwatch-${random_string.this.result}"
  environment = var.environment
}

resource "aws_iam_instance_profile" "this" {
  name = "ec2-instance-profile-${random_string.this.result}"
  role = module.cloudwatch.role_name
}

locals {
  user_data = templatefile("install_cloudwatch.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cloudwatch_agent.name
  })
}

resource "aws_ssm_parameter" "cloudwatch_agent" {
  description = "Cloudwatch agent config to configure custom log"
  name        = "/cloudwatch-agent/config"
  type        = "String"
  value       = file("amazon-cloudwatch-agent.json")
  overwrite   = true
}

// Allocate a fixed network interface for the instance with the specified subnet and security group
resource "aws_network_interface" "default_network_interface" {
  subnet_id       = tolist(data.aws_subnet_ids.subnet_ids.ids)[0]
  security_groups = var.security_group_ids

  tags = merge(var.tags, { Name = "${var.name}-eni" })
}

// Create an EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  ebs_optimized = true

  network_interface {
    device_index          = 0
    network_interface_id  = aws_network_interface.default_network_interface.id
    delete_on_termination = false
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

  key_name             = var.key_pair
  monitoring           = true
  iam_instance_profile = aws_iam_instance_profile.this.name
  user_data            = local.user_data

  tags = merge(var.tags, { "Name" = var.name })
}

resource "aws_ec2_tag" "root_volume_tag" {
  resource_id = aws_instance.ec2_instance.root_block_device[0].volume_id
  key         = "Name"
  value       = "${var.name}-root-volume"
}

// Optionally allocate a fixed public IP for the instance
resource "aws_eip" "public_ip" {
  count = var.allocate_public_ip ? 1 : 0
  vpc   = true

  tags = merge(var.tags, { Name = "${var.name}-eip" })
}

// Optionally associate the EIP to the instance
// (allows reattaching an existing EIP when the instance is recreated)
resource "aws_eip_association" "public_ip_association" {
  count = var.allocate_public_ip ? 1 : 0

  instance_id   = aws_instance.ec2_instance.id
  allocation_id = aws_eip.public_ip[0].id
}

resource "aws_ebs_volume" "data_disk" {
  count = var.data_disk_volume_size_gb == 0 ? 0 : 1

  availability_zone = var.availability_zone
  type              = "io1"
  size              = var.data_disk_volume_size_gb
  iops              = var.data_disk_volume_provisioned_iops
  encrypted         = true
  snapshot_id       = var.initial_database_disk_snapshot_id

  tags = merge(var.tags,
    {
      Name       = "${var.name}-data-volume"
      VolumeType = "data"
      Snapshot   = var.enable_disk_snapshots ? var.environment : false
    }
  )
}

resource "aws_volume_attachment" "data_disk_attachment" {
  count = var.data_disk_volume_size_gb == 0 ? 0 : 1

  volume_id   = aws_ebs_volume.data_disk[0].id
  instance_id = aws_instance.ec2_instance.id
  device_name = "/dev/sdh"
}
