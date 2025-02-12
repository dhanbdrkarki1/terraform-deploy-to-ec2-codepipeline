####################
# Dynamodb
####################

variable "create" {
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

# Tags
variable "custom_tags" {
  description = "Custom tags to set on all the resources."
  type        = map(string)
  default     = {}
}
