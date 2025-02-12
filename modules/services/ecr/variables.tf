#################################
# Elastic Container Registry
#################################

variable "create" {
  default     = false
  type        = bool
  description = "Specify whether to create resource or not"
}

variable "name" {
  description = "The name of the ECR registry."
  type        = string
  default     = null
}

variable "image_immutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE."
  type        = string
  default     = "IMMUTABLE"
}

variable "encryption_type" {
  description = "The type of encryption for ECR"
  type        = string
  default     = "KMS"
}

variable "force_delete" {
  description = " If true, will delete the repository even if it contains images. "
  type        = bool
  default     = false
}

variable "ecr_tags" {
  description = "Tags to set on the ECR."
  type        = map(string)
  default     = {}
}

variable "custom_tags" {
  description = "Custom tags to set on all the resources."
  type        = map(string)
  default     = {}
}
