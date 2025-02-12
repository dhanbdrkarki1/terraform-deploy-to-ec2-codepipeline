variable "create" {
  description = "Specify whether to create the resources or not."
  type        = bool
  default     = false
}

# Role
variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = ""
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "Assume role policy document"
  type        = string
  default     = null
}

variable "role_policies" {
  description = "Policies attached to the IAM role"
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default     = ""
}

variable "policy_description" {
  description = "Description of the IAM policy"
  type        = string
  default     = null
}

variable "policy_document" {
  description = "Policy document (only support JSON encoded)"
  type        = string
  default     = null
}

variable "create_ec2_instance_profile" {
  description = "Determines whether an EC2 instance profile is created or to use an existing IAM instance profile"
  type        = bool
  default     = false
}

variable "ec2_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name` or `name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role/profile created"
  type        = map(string)
  default     = {}
}


# IAM Users and Groups
variable "create_users" {
  description = "Whether to create IAM users"
  type        = bool
  default     = false
}

variable "create_groups" {
  description = "Whether to create IAM groups"
  type        = bool
  default     = false
}

variable "users" {
  description = "Map of user names to their configurations"
  type = map(object({
    path        = optional(string, "/")
    groups      = optional(list(string), [])
    policy_arns = optional(list(string), [])
    tags        = optional(map(string), {})
  }))
  default = {}
}

variable "groups" {
  description = "Map of group names to their configurations"
  type = map(object({
    path             = optional(string, "/")
    managed_policies = optional(list(string), [])
    custom_policies  = optional(list(string), [])
  }))
  default = {}
}

variable "custom_policies" {
  description = "Map of custom IAM policies to create"
  type = map(object({
    description = string
    policy      = any
    path        = optional(string, "/")
    tags        = optional(map(string), {})
  }))
  default = {}
}

variable "custom_tags" {
  description = "Custom tags to set on all the resources."
  type        = map(string)
  default     = {}
}
