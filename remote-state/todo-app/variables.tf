variable "project_name" {
  description = "Name of the Project"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment of the project"
  default     = null
  type        = string
}

# AWS Credentials
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

####################
# S3
####################
variable "create_s3_remote_state" {
  description = "If true, allow s3 remote state used by terraform."
  type        = bool
  default     = false
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = null
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}


variable "force_destroy" {
  description = "Force destroy the bucket even if it is not empty"
  type        = bool
  default     = false
}

variable "create_bucket_policy" {
  description = "Enable bucket policy for the bucket"
  type        = bool
  default     = false
}

####################
# Dynamodb
####################

variable "create_dynamodb_table_for_state_lock" {
  default     = false
  type        = bool
  description = "Specify whether to create dynamodb table resource or not"
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = null
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Name of the hash key in the index; must be defined as an attribute in the resource."
  type        = string
  default     = null

}

variable "attributes" {
  description = "List of DynamoDB attributes."
  type = list(object({
    name = string
    type = string
  }))
  default = []
}
