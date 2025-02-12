#########################


variable "create" {
  description = "Specify whether to create key pair or not"
  type        = bool
  default     = true
}


variable "algorithm_type" {
    default = "RSA"
    type = string
    description = "The Name of Algorithm to encrypt key"
}

variable "key_name" {
    description = "The name of key-pair attached to the instance"
    default = "ec2-key-pair"
    type = string
}

variable "dir" {
    description = "The location of the key pair in the system"
    type = string
    default = "~/.ssh"
}

variable "custom_tags" {
  description = "Custom tags to set on all the resources."
  type = map(string)
  default = {}
}
