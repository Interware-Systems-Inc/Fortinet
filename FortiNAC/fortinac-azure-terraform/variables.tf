variable "resource_group_name" {
  description = "Azure Resource Group Name"
  type        = string
  default     = "FortiHoL"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "canadacentral"
}

variable "vm_name" {
  description = "FortiNAC VM Name"
  type        = string
  default     = "DC-FTNT-NAC"
}

variable "admin_username" {
  description = "Admin username for FortiNAC"
  type        = string
  default     = "iws"
}

variable "admin_password" {
  description = "Admin password for FortiNAC"
  type        = string
  sensitive   = true
}

variable "public_ip_name" {
  description = "Public IP for FortiNAC"
  type        = string
  default     = "DC-FTNT-NAC-ip"
}

variable "vm_size" {
  description = "VM size for FortiNAC"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "network_interface_name" {
  description = "Network Interface for FortiNAC"
  type        = string
  default     = "dc-ftnt-nac370"
}

variable "network_security_group_name" {
  description = "NSG for FortiNAC"
  type        = string
  default     = "DC-FTNT-NAC-nsg"
}

variable "virtual_network_name" {
  description = "Virtual Network for FortiNAC"
  type        = string
  default     = "DC-FTNT-NAC-vnet"
}

variable "subnet_name" {
  description = "Subnet for FortiNAC"
  type        = string
  default     = "default"
}
variable "imageReferencePublisher" {
  description = "Image Publisher for FortiNAC VM"
  type        = string
  default     = "fortinet"
}

variable "imageReferenceOffer" {
  description = "Image Offer for FortiNAC VM"
  type        = string
  default     = "fortinet_fortinac"
}

variable "imageReferenceSku" {
  description = "Image SKU for FortiNAC VM"
  type        = string
  default     = "fortinet-fortinac"
}

variable "imageReferenceVersion" {
  description = "Image Version for FortiNAC VM"
  type        = string
  default     = "latest"
}
variable "networkInterfaceName" {
  description = "Network Interface for FortiNAC"
  type        = string
  default     = "dc-ftnt-nac370"
}
variable "enablePeriodicAssessment" {
  description = "Periodic assessment setting for the VM"
  type        = string
  default     = "ImageDefault"
}
