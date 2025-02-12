resource "aws_cloudwatch_log_group" "this" {
  count             = var.create ? 1 : 0
  name              = try(var.name, null)
  retention_in_days = var.retention_in_days
  kms_key_id        = try(var.kms_key_id, null)
  tags = merge(
    { Name = try(var.name, null) },
    var.custom_tags
  )

  # Optional: Enable encryption if specified
  # dynamic "encryption_configuration" {
  #   for_each = var.kms_key_id != null ? [1] : []
  #   content {
  #     kms_key_id = var.kms_key_id
  #   }
  # }
}


# AWS CloudWatch Logs Subscription
# resource "aws_cloudwatch_log_subscription_filter" "subscription_filter" {
#   count           = var.create ? length(var.subscription_filters) : 0
#   name            = "${local.name_prefix}-${var.subscription_filters[count.index].name}"
#   log_group_name  = var.subscription_filters[count.index].log_group_name
#   filter_pattern  = var.subscription_filters[count.index].filter_pattern
#   destination_arn = var.subscription_filters[count.index].destination_arn
#   role_arn        = var.subscription_filters[count.index].role_arn
# }
