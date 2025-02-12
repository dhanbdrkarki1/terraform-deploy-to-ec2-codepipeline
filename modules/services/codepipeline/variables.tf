####################
# AWS CodePipeline
####################
variable "create" {
  default     = false
  type        = bool
  description = "Specify whether to create resource or not"
}

variable "pipeline_type" {
  description = "Type of the pipeline. Possible values are: V1 and V2. Default value is V1."
  type        = string
  default     = "V2"
}

variable "pipeline_execution_mode" {
  description = "The method that the pipeline will use to handle multiple executions. The default mode is SUPERSEDED. "
  default     = "QUEUED"
  type        = string

  validation {
    condition = (
      contains(["SUPERSEDED", "QUEUED", "PARALLEL"], var.pipeline_execution_mode) &&
      (var.pipeline_type == "V1" && var.pipeline_execution_mode == "SUPERSEDED") ||
      (var.pipeline_type == "V2" && contains(["QUEUED", "PARALLEL"], var.pipeline_execution_mode))
    )
    error_message = "The pipeline_execution_mode must be 'SUPERSEDED' for V1 pipelines and can be 'QUEUED' or 'PARALLEL' for V2 pipelines."
  }
}

variable "codepipeline_artifact_bucket" {
  type        = string
  description = "The S3 artifact bucket for CodePipeline"
  default     = null
}

variable "enable_kms_encryption" {
  description = "Flag to enable KMS encryption for the artifact store"
  type        = bool
  default     = false
}

variable "kms_encryption_key_arn" {
  type        = string
  description = <<-DOC
    The encryption key block AWS CodePipeline uses to encrypt the data in the artifact store, such as an AWS Key Management Service (AWS KMS) key. 
    If you don't specify a key, AWS CodePipeline uses the default key for Amazon Simple Storage Service (Amazon S3). 
  DOC
  default     = null
}

variable "stages" {
  description = "A list of stages for the AWS CodePipeline, where each stage contains an action with its configuration details."
  type = list(object({
    name = string
    action = object({
      name             = string                 # Name of the action within the stage
      category         = string                 # The category of the action (e.g., Source, Build, Deploy)
      owner            = string                 # The owner of the action (e.g., AWS, ThirdParty, Custom)
      provider         = string                 # The service provider for the action (e.g., CodeBuild, S3, Lambda)
      version          = string                 # The version of the action provider
      configuration    = map(string)            # Key-value pairs of action-specific configuration settings
      input_artifacts  = optional(list(string)) # List of input artifacts for the action
      output_artifacts = optional(list(string)) # List of output artifacts for the action
      run_order        = optional(number, 1)    # The order in which the action runs within the stage (default: 1)
    })
  }))
  default = []
}

# IAM Role
variable "codepipeline_service_role_arn" {
  type        = string
  description = "The ARN of the IAM role that enables AWS CodePipeline to interact with dependent AWS services on behalf of the AWS account."
  default     = null
}

# Tags
variable "custom_tags" {
  description = "Custom tags to set on all the resources."
  type        = map(string)
  default     = {}
}
