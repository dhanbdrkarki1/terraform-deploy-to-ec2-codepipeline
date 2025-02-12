# EC2 Instance Connect Endpoint
resource "aws_ec2_instance_connect_endpoint" "this" {
  for_each = var.create_instance_connect_endpoint ? var.instance_connect_endpoints : {}

  subnet_id          = each.value.subnet_id
  security_group_ids = each.value.security_group_ids

  tags = merge(
    {
      Name = "${local.name_prefix}-eic-endpoint-${each.key}"
    },
    var.custom_tags
  )
}
