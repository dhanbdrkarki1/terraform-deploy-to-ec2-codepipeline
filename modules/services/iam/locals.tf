locals {
  name_prefix = "${var.custom_tags["Project"] != "" ? var.custom_tags["Project"] : "default-project"}-${var.custom_tags["Environment"] != "" ? var.custom_tags["Environment"] : "default-env"}"
  # pairs for managed policies
  group_managed_policy_pairs = flatten([
    for group_name, group in var.groups : [
      for policy_arn in lookup(group, "managed_policies", []) : {
        group_name = group_name
        policy_arn = policy_arn
      }
    ]
  ])

  # pairs for custom policies (only if custom policies are defined)
  group_custom_policy_pairs = flatten([
    for group_name, group in var.groups : [
      for policy_name in lookup(group, "custom_policies", []) : {
        group_name  = group_name
        policy_name = policy_name
      }
      if length(var.custom_policies) > 0
    ]
  ])

  # pairs for user direct policy attachments
  user_policy_pairs = flatten([
    for user_name, user in var.users : [
      for policy_arn in lookup(user, "policy_arns", []) : {
        user_name  = user_name
        policy_arn = policy_arn
      }
    ]
  ])
}


