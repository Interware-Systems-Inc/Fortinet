variable "vnet_name" {
  default = "FortiNAC-VNet"
}

variable "management_subnet_name" {
  default = "Management-Subnet"
}

variable "internal_subnet_name" {
  default = "Internal-Subnet"
}

variable "mgmt_nsg_name" {
  default = "FortiNAC-NSG"
}

variable "vm_size" {
  default = "Standard_F4s_v2"
}

variable "admin_username" {
  default = "fortinacadmin"
}

variable "admin_password" {
  default = "YourStrongPassword123!"
}
