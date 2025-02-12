########################
# AWS IAM Role
########################

# Allow the IAM role to be assumed by EC2 instances
data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create_ec2_instance_profile ? 1 : 0

  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "this" {
  count       = var.create ? 1 : 0
  name        = var.role_name != "" ? "${local.name_prefix}-${var.role_name}" : "${local.name_prefix}-role"
  description = var.role_description
  assume_role_policy = coalesce(
    var.assume_role_policy,
    var.create_ec2_instance_profile ? data.aws_iam_policy_document.assume_role_policy[0].json : jsonencode({})
  )

  tags = merge(
    { Name = var.role_name },
    var.custom_tags
  )
}

# IAM Policy
resource "aws_iam_policy" "this" {
  count       = var.create && var.policy_document != null ? 1 : 0
  name        = var.policy_name != "" ? "${local.name_prefix}-${var.policy_name}" : "${local.name_prefix}-${var.role_name}"
  description = try(var.policy_description, null)
  policy      = try(var.policy_document, null)

  tags = merge(
    { Name = var.policy_name != "" ? var.policy_name : var.role_name },
    var.custom_tags
  )
}


# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "this" {
  count      = var.create && var.policy_document != null ? 1 : 0
  role       = try(aws_iam_role.this[0].name, null)
  policy_arn = try(aws_iam_policy.this[0].arn, null)

  depends_on = [aws_iam_role.this, aws_iam_policy.this] # Ensure role and policy are created first
}

# Allow to use managed policies if passed:
#  role_policies = {
#   EC2FullAccess = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }

resource "aws_iam_role_policy_attachment" "role_policies_attachment" {
  for_each = { for k, v in var.role_policies : k => v if var.role_policies != "" }

  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "this" {
  count = var.create_ec2_instance_profile ? 1 : 0
  role  = try(aws_iam_role.this[0].name, null)
  name  = var.role_name != "" ? "${local.name_prefix}-${var.role_name}" : "${local.name_prefix}-EC2InstanceProfile"

  tags = merge(
    { "Name" = "${local.name_prefix}" },
    var.custom_tags,
    var.iam_role_tags
  )

  # lifecycle {
  #   create_before_destroy = true
  # }
}
