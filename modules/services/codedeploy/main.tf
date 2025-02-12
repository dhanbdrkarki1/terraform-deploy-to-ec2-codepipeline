#================================
#     AWS CodeDeploy 
#================================
locals {
  name_prefix = lower("${var.custom_tags["Project"] != "" ? var.custom_tags["Project"] : "default-project"}-${var.custom_tags["Environment"] != "" ? var.custom_tags["Environment"] : "default-env"}-${var.name}")
  # enable_auto_rollback_configuration = var.create && var.auto_rollback_configuration != null && length(var.auto_rollback_configuration) > 0
  enable_alarm_configuration = var.create && var.alarm_configuration != null
}

# App defintion
resource "aws_codedeploy_app" "this" {
  count            = var.create ? 1 : 0
  name             = local.name_prefix
  compute_platform = var.compute_platform
  tags = merge(
    { Name = "${local.name_prefix}" },
    var.custom_tags
  )
}

# CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "this" {
  count                  = var.create ? 1 : 0
  app_name               = try(aws_codedeploy_app.this[0].name, null)
  deployment_config_name = var.deployment_config_name
  deployment_group_name  = "${local.name_prefix}-dg"
  service_role_arn       = var.codedeploy_service_role
  autoscaling_groups     = var.autoscaling_groups

  dynamic "ec2_tag_filter" {
    for_each = length(var.ec2_tag_filter) > 0 ? var.ec2_tag_filter : []

    content {
      key   = lookup(ec2_tag_filter.value, "key", null)
      type  = lookup(ec2_tag_filter.value, "type", null)
      value = lookup(ec2_tag_filter.value, "value", null)
    }
  }

  # Note that you cannot have both ec_tag_filter and ec2_tag_set vars set!
  # See https://docs.aws.amazon.com/cli/latest/reference/deploy/create-deployment-group.html for details
  dynamic "ec2_tag_set" {
    for_each = length(var.ec2_tag_set) > 0 ? var.ec2_tag_set : []

    content {
      dynamic "ec2_tag_filter" {
        for_each = ec2_tag_set.value.ec2_tag_filter
        content {
          key   = lookup(ec2_tag_filter.value, "key", null)
          type  = lookup(ec2_tag_filter.value, "type", null)
          value = lookup(ec2_tag_filter.value, "value", null)
        }
      }
    }
  }

  # dynamic "auto_rollback_configuration" {
  #   for_each = local.enable_auto_rollback_configuration ? [1] : [0]

  #   content {
  #     enabled = try(auto_rollback_configuration.value.enabled, null)
  #     events  = try(auto_rollback_configuration.value.events, null)
  #   }
  # }

  dynamic "ecs_service" {
    for_each = var.ecs_service == null ? [] : var.ecs_service

    content {
      cluster_name = ecs_service.value.cluster_name
      service_name = ecs_service.value.service_name
    }
  }

  dynamic "load_balancer_info" {
    for_each = var.load_balancer_info == null ? [] : [var.load_balancer_info]

    content {
      dynamic "elb_info" {
        for_each = lookup(load_balancer_info.value, "elb_info", null) == null ? [] : [load_balancer_info.value.elb_info]

        content {
          name = elb_info.value.name
        }
      }

      dynamic "target_group_info" {
        for_each = lookup(load_balancer_info.value, "target_group_info", null) == null ? [] : [load_balancer_info.value.target_group_info]

        content {
          name = target_group_info.value.name
        }
      }

      dynamic "target_group_pair_info" {
        for_each = lookup(load_balancer_info.value, "target_group_pair_info", null) == null ? [] : [load_balancer_info.value.target_group_pair_info]

        content {

          dynamic "prod_traffic_route" {
            for_each = lookup(target_group_pair_info.value, "prod_traffic_route", null) == null ? [] : [target_group_pair_info.value.prod_traffic_route]

            content {
              listener_arns = prod_traffic_route.value.listener_arns
            }
          }

          dynamic "target_group" {
            for_each = lookup(target_group_pair_info.value, "target_group", null) == null ? [] : [target_group_pair_info.value.target_group]

            content {
              name = target_group.value.name
            }
          }

          dynamic "target_group" {
            for_each = lookup(target_group_pair_info.value, "blue_target_group", null) == null ? [] : [target_group_pair_info.value.blue_target_group]

            content {
              name = target_group.value.name
            }
          }

          dynamic "target_group" {
            for_each = lookup(target_group_pair_info.value, "green_target_group", null) == null ? [] : [target_group_pair_info.value.green_target_group]

            content {
              name = target_group.value.name
            }
          }

          dynamic "test_traffic_route" {
            for_each = lookup(target_group_pair_info.value, "test_traffic_route", null) == null ? [] : [target_group_pair_info.value.test_traffic_route]

            content {
              listener_arns = test_traffic_route.value.listener_arns
            }
          }
        }
      }
    }
  }

  # dynamic "trigger_configuration" {
  #   for_each = local.sns_topic_arn == null ? [0] : [1]

  #   content {
  #     trigger_events     = var.trigger_events
  #     trigger_name       = module.this.id
  #     trigger_target_arn = local.sns_topic_arn
  #   }
  # }

  dynamic "alarm_configuration" {
    for_each = local.enable_alarm_configuration ? [var.alarm_configuration] : []

    content {
      alarms                    = lookup(alarm_configuration.value, "alarms", null)
      ignore_poll_alarm_failure = lookup(alarm_configuration.value, "ignore_poll_alarm_failure", null)
      enabled                   = local.enable_alarm_configuration
    }
  }

  dynamic "blue_green_deployment_config" {
    for_each = var.blue_green_deployment_config == null ? [] : [var.blue_green_deployment_config]
    content {
      dynamic "deployment_ready_option" {
        for_each = lookup(blue_green_deployment_config.value, "deployment_ready_option", null) == null ? [] : [lookup(blue_green_deployment_config.value, "deployment_ready_option", {})]

        content {
          action_on_timeout    = lookup(deployment_ready_option.value, "action_on_timeout", null)
          wait_time_in_minutes = lookup(deployment_ready_option.value, "wait_time_in_minutes", null)
        }
      }

      dynamic "green_fleet_provisioning_option" {
        for_each = lookup(blue_green_deployment_config.value, "green_fleet_provisioning_option", null) == null ? [] : [lookup(blue_green_deployment_config.value, "green_fleet_provisioning_option", {})]

        content {
          action = lookup(green_fleet_provisioning_option.value, "action", null)
        }
      }

      dynamic "terminate_blue_instances_on_deployment_success" {
        for_each = lookup(blue_green_deployment_config.value, "terminate_blue_instances_on_deployment_success", null) == null ? [] : [lookup(blue_green_deployment_config.value, "terminate_blue_instances_on_deployment_success", {})]

        content {
          action                           = lookup(terminate_blue_instances_on_deployment_success.value, "action", null)
          termination_wait_time_in_minutes = lookup(terminate_blue_instances_on_deployment_success.value, "termination_wait_time_in_minutes", null)
        }
      }
    }
  }

  dynamic "deployment_style" {
    for_each = var.deployment_style == null ? [] : [var.deployment_style]

    content {
      deployment_option = deployment_style.value.deployment_option
      deployment_type   = deployment_style.value.deployment_type
    }
  }

  # lifecycle {
  #   ignore_changes = [blue_green_deployment_config]
  # }

  outdated_instances_strategy = var.outdated_instances_strategy
  depends_on                  = [aws_codedeploy_app.this]

  tags = merge(
    { Name = "${local.name_prefix}-dg" },
    var.custom_tags
  )
}
