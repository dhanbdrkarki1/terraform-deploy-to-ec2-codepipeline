########################
# AWS IAM User and Groups
########################

# IAM Users
resource "aws_iam_user" "users" {
  for_each = var.create_users ? var.users : {}

  name = each.key
  path = lookup(each.value, "path", "/")

  tags = merge(
    { Name = each.key },
    var.custom_tags,
    lookup(each.value, "tags", {})
  )
}

# IAM Groups
resource "aws_iam_group" "groups" {
  for_each = var.create_groups ? var.groups : {}

  name = each.key
  path = lookup(each.value, "path", "/")
}

# Custom IAM Policies
resource "aws_iam_policy" "custom_policies" {
  for_each = var.create_groups && length(var.custom_policies) > 0 ? var.custom_policies : {}

  name        = "${local.name_prefix}-${each.key}"
  description = each.value.description
  policy      = jsonencode(each.value.policy)
  path        = lookup(each.value, "path", "/")
  tags = merge(
    var.custom_tags,
    lookup(each.value, "tags", {})
  )
}

# User group membership
resource "aws_iam_user_group_membership" "user_groups" {
  for_each = var.create_users && var.create_groups ? var.users : {}
  user     = aws_iam_user.users[each.key].name
  groups = [
    for group in lookup(each.value, "groups", []) :
    var.create_groups ? aws_iam_group.groups[group].name : group
  ]
}

# Attach Managed Policies to Groups
resource "aws_iam_group_policy_attachment" "managed_policy" {
  for_each = var.create_groups ? {
    for policy in local.group_managed_policy_pairs : "${policy.group_name}.${policy.policy_arn}" => policy
  } : {}

  group      = aws_iam_group.groups[each.value.group_name].name
  policy_arn = each.value.policy_arn

  depends_on = [aws_iam_group.groups]
}

# Attach Custom Policies to Groups
resource "aws_iam_group_policy_attachment" "custom_policy" {
  for_each = var.create_groups && length(var.custom_policies) > 0 ? {
    for policy in local.group_custom_policy_pairs : "${policy.group_name}.${policy.policy_name}" => policy
  } : {}

  group      = aws_iam_group.groups[each.value.group_name].name
  policy_arn = aws_iam_policy.custom_policies[each.value.policy_name].arn

  depends_on = [aws_iam_group.groups, aws_iam_policy.custom_policies]
}

# Direct User Policy Attachments (if needed)
resource "aws_iam_user_policy_attachment" "user_policies" {
  for_each = var.create_users ? {
    for policy in local.user_policy_pairs : "${policy.user_name}.${policy.policy_arn}" => policy
  } : {}

  user       = aws_iam_user.users[each.value.user_name].name
  policy_arn = each.value.policy_arn

  depends_on = [aws_iam_user.users]
}


