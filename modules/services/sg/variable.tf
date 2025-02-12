####################
# Security Group
####################

variable "create" {
  default     = false
  type        = bool
  description = "Specify whether to create resource or not"
}

variable "security_group_id" {
  description = "ID of existing security group whose rules we will manage"
  type        = string
  default     = null
}


variable "name" {
  type        = string
  description = "The name of the security group"
  default     = null
}

variable "description" {
  type        = string
  description = "The description for the security group"
  default     = "Security Group managed by Terraform"
}

variable "vpc_id" {
  type        = string
  description = "The id of the VPC where to create security group"
  default     = null
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. Enable for EMR."
  type        = bool
  default     = false
}


variable "create_timeout" {
  description = "Time to wait for a security group to be created"
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Time to wait for a security group to be deleted"
  type        = string
  default     = "15m"
}

variable "security_group_tags" {
  description = "The tags for security groups."
  type        = map(string)
  default     = {}
}



variable "custom_tags" {
  description = "The custom tags for the security group."
  type        = map(string)
  default     = {}
}


variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = map(list(any))

  default = {
    # HTTP
    http-80-tcp   = [80, 80, "tcp", "HTTP"]
    http-8080-tcp = [8080, 8080, "tcp", "HTTP"]
    # HTTPS
    https-443-tcp  = [443, 443, "tcp", "HTTPS"]
    https-8443-tcp = [8443, 8443, "tcp", "HTTPS"]
    # MySQL
    mysql-3306-tcp = [3306, 3306, "tcp", "MySQL/Aurora"]
    # MSSQL Server
    mssql-tcp = [1433, 1433, "tcp", "MSSQL Server"]
    # PostgreSQL
    postgresql-5432-tcp = [5432, 5432, "tcp", "PostgreSQL"]
    # SSH
    ssh-tcp = [22, 22, "tcp", "SSH"]
    # Redis
    redis-tcp = [6379, 6379, "tcp", "Redis"]

    # Memcached
    memcached-tcp = [11211, 11211, "tcp", "Memcached"]

    # NFS/EFS
    nfs-tcp = [2049, 2049, "tcp", "NFS/EFS"]

    # django-port
    django-8000-tcp = [8000, 8000, "tcp", "Django"]

    # node
    node-3000-tcp = [3000, 3000, "tcp", "Node"]

    # react
    react-3000-tcp = [3000, 3000, "tcp", "React"]

    # Monitoring
    prometheus-9090-tcp    = [9090, 9090, "tcp", "Prometheus Monitoring"]
    grafana-3000-tcp       = [3000, 3000, "tcp", "Grafana"]
    node-exporter-9100-tcp = [9100, 9100, "tcp", "Node Exporter"]
    loki-3100-tcp          = [3100, 3100, "tcp", "Loki"]

    all-all       = [-1, -1, "-1", "All protocols"]
    all-tcp       = [0, 65535, "tcp", "All TCP ports"]
    all-udp       = [0, 65535, "udp", "All UDP ports"]
    all-icmp      = [-1, -1, "icmp", "All IPV4 ICMP"]
    all-ipv6-icmp = [-1, -1, 58, "All IPV6 ICMP"]
    # This is a fallback rule to pass to lookup() as default. It does not open anything, because it should never be used.
    _ = ["", "", ""]
  }
}

# ingress
variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}



variable "ingress_with_self" {
  description = "List of ingress rules to create where 'self' is defined"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  type        = list(map(string))
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}







#########
# Egress
#########
variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}

variable "egress_with_self" {
  description = "List of egress rules to create where 'self' is defined"
  type        = list(map(string))
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "egress_with_source_security_group_id" {
  description = "List of egress rules to create where 'source_security_group_id' is used"
  type        = list(map(string))
  default     = []
}


variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


# variable "ingress_rules" {
#   type = list(object({
#     from_port       = number
#     to_port         = number
#     protocol        = string
#     cidr_blocks     = optional(list(string))
#     security_groups = optional(list(string))
#   }))
#   description = "List of ingress rules for the security group"
#   default     = []
# }

# variable "egress_rules" {
#   type = list(object({
#     from_port       = number
#     to_port         = number
#     protocol        = string
#     cidr_blocks     = optional(list(string))
#     security_groups = optional(list(string))
#   }))
#   description = "List of egress rules for the security group"
#   default     = []
# }
