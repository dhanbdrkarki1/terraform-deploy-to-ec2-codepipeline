variable "create" {
  description = "If true, allow to create an instance"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

# AMI
variable "IsUbuntu" {
  description = "The OS is of type Ubuntu or not"
  type        = bool
  default     = false
}


variable "ami_id" {
  description = "Specific AMI ID to use. If provided, this will override ami_type"
  type        = string
  default     = null
}

variable "ami_type" {
  description = "Type of AMI to use. Only used if ami_id is not provided"
  type        = string
  default     = "amazon_linux2"
  validation {
    condition     = contains(["amazon_linux2", "amazon_linux2023", "ubuntu_22", "ubuntu_24"], var.ami_type)
    error_message = "Valid values for ami_type are: amazon_linux2, amazon_linux2023, ubuntu_22, ubuntu_24"
  }
}

variable "create_ami_from_instance" {
  description = "Set to true, to create ami from existing ec2 instance"
  default     = false
  type        = bool
}

variable "ami_name" {
  description = "Name of the AMI to be created"
  type        = string
  default     = null
}

variable "source_instance_id" {
  description = "ID of the instance to create the AMI from"
  type        = string
  default     = null
}

variable "snapshot_without_reboot" {
  description = "Set to true if you don't want the instance to be rebooted when creating the AMI"
  type        = bool
  default     = false
}



variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
  default     = "t2.micro"
}

variable "availability_zones" {
  description = "The list of availability zones where the instances reside"
  type        = list(string)
  default     = []
}



variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template"
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = null
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
  default     = null
}


variable "subnet_ids" {
  description = "The list of VPC Subnet IDs to launch in, corresponding to the availability zones"
  type        = list(string)
  default     = []
}


variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "security_groups_ids" {
  description = "The list of security group names to associate with."
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data to provide when launching the instance."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  type        = bool
  description = "Destroy and recreate instance on user_data update"
  default     = false
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}


# EBS - attached volume
variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = list(any)
  default     = []
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(any)
  default     = []
}


variable "volume_size" {
  description = "Size of the volume in gibibytes (GiB)"
  default     = 8
  type        = number
}

variable "volume_type" {
  description = "Type of the volume."
  default     = "gp2"
  type        = string
}



variable "delete_ebs_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
  type        = bool
}

variable "encrypt_ebs" {
  description = "Whether to enable volume encryption."
  default     = false
  type        = bool
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "enable_volume_tags" {
  description = "Whether to enable volume tags (if enabled it conflicts with root_block_device tags)"
  type        = bool
  default     = true
}




# iam
variable "create_iam_instance_profile" {
  description = "Determines whether an IAM instance profile is created or to use an existing IAM instance profile"
  type        = bool
  default     = false
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
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

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "iam_role_policies" {
  description = "Policies attached to the IAM role"
  type        = map(string)
  default     = {}
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role/profile created"
  type        = map(string)
  default     = {}
}

# Instance Connect Endpoint
variable "create_instance_connect_endpoint" {
  description = "Whether to create EC2 Instance Connect Endpoint"
  type        = bool
  default     = false
}

variable "instance_connect_endpoints" {
  description = "Map of EC2 Instance Connect Endpoints to create"
  type = map(object({
    subnet_id          = optional(string, null)
    security_group_ids = optional(list(string), [])
  }))
  default = {}
}





# Tags
variable "ec2_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "custom_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
