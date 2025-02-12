# AMI from EC2 instance
resource "aws_ami_from_instance" "this" {
  count                   = var.create_ami_from_instance ? 1 : 0
  name                    = "${local.name_prefix}-${var.ami_name}"
  source_instance_id      = var.source_instance_id
  snapshot_without_reboot = var.snapshot_without_reboot

  tags = merge(
    {
      Name = "${local.name_prefix}-${var.ami_name}"
    },
    var.custom_tags
  )
  depends_on = [var.source_instance_id]
}
