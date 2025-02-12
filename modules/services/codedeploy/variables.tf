variable "create" {
  default     = false
  type        = bool
  description = "Specify whether to create resource or not"
}

# Application
variable "name" {
  description = "The name of the CodeDeploy application"
  type        = string
  default     = null
}

variable "compute_platform" {
  type        = string
  default     = "Server"
  description = "The compute platform can either be ECS, Lambda, or Server."
}

# Deployment Group
variable "deployment_config_name" {
  type        = string
  default     = "CodeDeployDefault.ECSAllAtOnce" # for EC2, "CodeDeployDefault.AllAtOnce"
  description = "The name of the group's deployment config."
}

variable "autoscaling_groups" {
  type        = list(string)
  description = "A list of Autoscaling Groups associated with the deployment group."
  default     = []
}

variable "auto_rollback_configuration" {
  type = object({
    enabled = bool
    events  = list(string)
  })
  default     = null
  description = <<-DOC
    Configuration block of the automatic rollback configuration associated with the deployment group.
    The event type or types that trigger a rollback. Supported types are `DEPLOYMENT_FAILURE` and `DEPLOYMENT_STOP_ON_ALARM`."
  DOC
}

variable "ec2_tag_filter" {
  type = set(object({
    key   = string
    type  = string
    value = string
  }))
  default     = []
  description = <<-DOC
    The Amazon EC2 tags on which to filter. The deployment group includes EC2 instances with any of the specified tags.
    Cannot be used in the same call as ec2TagSet.
  DOC
}

variable "ec2_tag_set" {
  type = set(object(
    {
      ec2_tag_filter = set(object(
        {
          key   = string
          type  = string
          value = string
        }
      ))
    }
  ))
  default     = []
  description = <<-DOC
    A list of sets of tag filters. If multiple tag groups are specified,
    any instance that matches to at least one tag filter of every tag group is selected.

    key:
      The key of the tag filter.
    type:
      The type of the tag filter, either `KEY_ONLY`, `VALUE_ONLY`, or `KEY_AND_VALUE`.
    value:
      The value of the tag filter.
  DOC
}

# ECS Service
variable "ecs_service" {
  type = list(object({
    cluster_name = string
    service_name = string
  }))
  default     = null
  description = <<-DOC
    Configuration block(s) of the ECS services for a deployment group.

    cluster_name:
      The name of the ECS cluster. 
    service_name:
      The name of the ECS service.
  DOC
}

# Load Balancer
variable "load_balancer_info" {
  type        = map(any)
  default     = null
  description = <<-DOC
    Single configuration block of the load balancer to use in a blue/green deployment, 
    see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group#load_balancer_info
  DOC
}

variable "trigger_events" {
  type        = list(string)
  default     = ["DeploymentFailure"]
  description = <<-DOC
    The event type or types for which notifications are triggered. 
    Some values that are supported: 
      `DeploymentStart`, `DeploymentSuccess`, `DeploymentFailure`, `DeploymentStop`, 
      `DeploymentRollback`, `InstanceStart`, `InstanceSuccess`, `InstanceFailure`. 
    See the CodeDeploy documentation for all possible values.
    http://docs.aws.amazon.com/codedeploy/latest/userguide/monitoring-sns-event-notifications-create-trigger.html 
  DOC
}

variable "alarm_configuration" {
  type = object({
    alarms                    = list(string)
    ignore_poll_alarm_failure = bool
  })
  default     = null
  description = <<-DOC
     Configuration of deployment to stop when a CloudWatch alarm detects that a metric has fallen below or exceeded a defined threshold.
      alarms:
        A list of alarms configured for the deployment group.
      ignore_poll_alarm_failure:
        Indicates whether a deployment should continue if information about the current state of alarms cannot be retrieved from CloudWatch.
  DOC
}

variable "blue_green_deployment_config" {
  type        = any
  default     = null
  description = <<-DOC
    Configuration block of the blue/green deployment options for a deployment group, 
    see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group#blue_green_deployment_config
  DOC
}

variable "deployment_style" {
  type = object({
    deployment_option = string
    deployment_type   = string
  })
  default     = null
  description = <<-DOC
    Configuration of the type of deployment, either in-place or blue/green, 
    you want to run and whether to route deployment traffic behind a load balancer.

    deployment_option:
      Indicates whether to route deployment traffic behind a load balancer. 
      Possible values: `WITH_TRAFFIC_CONTROL`, `WITHOUT_TRAFFIC_CONTROL`.
    deployment_type:
      Indicates whether to run an in-place deployment or a blue/green deployment.
      Possible values: `IN_PLACE`, `BLUE_GREEN`.
  DOC
}

variable "outdated_instances_strategy" {
  type        = string
  default     = "UPDATE"
  description = <<-DOC
    Configuration block of Indicates what happens when new Amazon EC2 instances are launched mid-deployment 
    and do not receive the deployed application revision. 
    Valid values are UPDATE and IGNORE.
  DOC
}

# IAM Role
variable "codedeploy_service_role" {
  type        = string
  default     = null
  description = "The service IAM role ARN that allows deployments."
}

# Environment
variable "ecs_cluster" {
  description = "The name of the ECS cluster where to deploy"
  type        = string
  default     = null
}

# Load Balancers
variable "alb_listener_arn" {
  description = "The ARN of the ALB listener for production"
  type        = string
  default     = null
}

variable "target_group_blue" {
  description = "The Target group name for the Blue part"
  type        = string
  default     = null
}

variable "target_group_green" {
  description = "The Target group name for the Green part"
  type        = string
  default     = null
}

# Tags
variable "custom_tags" {
  description = "Custom tags to be applied to the codebuild project"
  type        = map(string)
  default     = {}
}
