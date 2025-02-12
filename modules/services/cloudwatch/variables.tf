variable "create" {
  description = "Specify whether to create subscription filter or not."
  type        = bool
  default     = false
}

variable "subscription_filters" {
  description = "List of subscription filters to create"
  type = list(object({
    name            = string
    log_group_name  = string
    filter_pattern  = string
    destination_arn = string
    role_arn        = string
  }))
  default = []
}

# CloudWatch Log Group
variable "name" {
  description = "Name of the CloudWatch log group"
  type        = string
  default     = null
}


variable "retention_in_days" {
  type        = string
  description = "The number of days to retain CloudWatch logs for the build project."
  default     = 30
}

variable "kms_key_id" {
  type        = string
  description = "The KMS id for Cloudwatch logs group"
  default     = null
}


variable "custom_tags" {
  description = "Custom tags to set on all the resources."
  type        = map(string)
  default     = {}
}

