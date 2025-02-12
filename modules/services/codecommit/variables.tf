####################
# AWS CodeBuild
####################

variable "create" {
  default     = false
  type        = bool
  description = "Specify whether to create resource or not"
}

variable "repository_name" {
  type        = string
  default     = "testrepo"
  description = "The name for the repository. This needs to be less than 100 characters."
}

variable "description" {
  type        = string
  default     = "This is the Sample App Repository"
  description = "The description of the repository. This needs to be less than 1000 characters."
}

variable "custom_tags" {
  description = "Custom tags to set on all the resources."
  type        = map(string)
  default     = {}
}
