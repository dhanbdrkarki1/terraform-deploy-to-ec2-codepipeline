####################
# S3
####################

variable "create" {
  default     = false
  type        = bool
  description = "Specify whether to create resource or not"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Force destroy the bucket even if it is not empty"
  type        = bool
  default     = false
}

variable "prevent_destroy" {
  description = "Prevent the bucket from being destroyed"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

# ACL
variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "enable_ownership_controls" {
  description = "Enable ownership controls for the bucket"
  type        = bool
  default     = true
}


# for acl
variable "enable_acl" {
  description = "Enable ACL for the bucket"
  type        = bool
  default     = true
}

variable "bucket_acl" {
  type        = string
  default     = "private"
  description = <<EOT
              Specifies the S3 bucket's predefined ACL to manage access permissions. 
              Valid values are: 'private' (default), 'public-read', 'public-read-write', 'authenticated-read', 'log-delivery-write', 'aws-exec-read', 'bucket-owner-read', and 'bucket-owner-full-control'. Use 'private' for secure configurations.
              EOT
}

variable "create_bucket_policy" {
  description = "Enable bucket policy for the bucket"
  type        = bool
  default     = false
}

variable "bucket_policy" {
  description = "The JSON policy to apply to the bucket"
  type        = string
  default     = null
}

variable "cors_rule" {
  description = "List of maps containing rules for Cross-Origin Resource Sharing."
  type        = any
  default     = []
}

variable "expected_bucket_owner" {
  description = "The account ID of the expected bucket owner"
  type        = string
  default     = null
}

variable "custom_tags" {
  description = "Custom tags to set on all the resources."
  type        = map(string)
  default     = {}
}
