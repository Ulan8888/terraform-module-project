variable region {
    type = string
    default = ""
}
variable vpc_cidr {
    type = string
    default = ""
}
variable subnet_cidr1 {
    type = string
    default = ""
}
variable subnet_cidr2 {
    type = string
    default = ""
}
variable subnet_cidr3 {
    type = string
    default = ""
}
variable az1 {
    type = string
    default = ""
}
variable az2 {
    type = string
    default = ""
}
variable az3 {
    type = string
    default = ""
}
variable ip_on_launch {
    type = bool
    default = true
}
variable key_name {
  type        = string
  default     = ""
  description = "Enter a key name"
}
variable az {
    type = string
    default = ""
}
variable bucket {
    type = string
    default = ""
}
variable key {
    type = string
    default = ""
}

# variable instance_type {
#     type = "" 
#     default = ""
# }

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  # Replace with your desired CIDR block
}
