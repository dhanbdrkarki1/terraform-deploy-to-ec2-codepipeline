locals {
  name_prefix = "${var.custom_tags["Project"] != "" ? var.custom_tags["Project"] : "default-project"}-${var.custom_tags["Environment"] != "" ? var.custom_tags["Environment"] : "default-env"}-${var.name != "" ? var.name : "default-name"}"
  ami_map = {
    amazon_linux2    = data.aws_ami.linux2.id
    amazon_linux2023 = data.aws_ami.linux2023.id
    ubuntu_22        = data.aws_ami.ubuntu_22.id
    # ubuntu_24        = data.aws_ami.ubuntu_24.id
  }

  # Use ami_id if provided, otherwise use the AMI based on ami_type
  final_ami_id = coalesce(var.ami_id, local.ami_map[var.ami_type])
}


resource "aws_instance" "this" {
  count                       = var.create ? length(var.availability_zones) : 0
  ami                         = local.final_ami_id
  instance_type               = var.instance_type
  availability_zone           = element(var.availability_zones, count.index)
  subnet_id                   = element(var.subnet_ids, count.index)
  vpc_security_group_ids      = var.security_groups_ids
  hibernation                 = var.hibernation
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  iam_instance_profile        = try(var.iam_instance_profile, null)

  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.delete_ebs_on_termination
    encrypted             = var.encrypt_ebs
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = try(ebs_block_device.value.encrypted, null)
      iops                  = try(ebs_block_device.value.iops, null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = try(ebs_block_device.value.volume_size, null)
      volume_type           = try(ebs_block_device.value.volume_type, null)
      throughput            = try(ebs_block_device.value.throughput, null)
      tags                  = try(ebs_block_device.value.tags, null)
    }
  }

  tags = merge(
    { "Name" = "${local.name_prefix}-${var.availability_zones[count.index]}" },
    var.ec2_tags,
    var.custom_tags
  )
}
