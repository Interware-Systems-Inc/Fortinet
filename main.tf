terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Use existing Resource Group "FortiHoL"
data "azurerm_resource_group" "fortihol" {
  name = "FortiHoL"
}

# Virtual Network
resource "azurerm_virtual_network" "fortinac_vnet" {
  name                = "iws-nac-vnet"
  location            = data.azurerm_resource_group.fortihol.location
  resource_group_name = data.azurerm_resource_group.fortihol.name
  address_space       = ["10.0.0.0/16"]
}

# Management Subnet (10.0.0.0/24)
resource "azurerm_subnet" "management" {
  name                 = "mgmt-subnet"
  resource_group_name  = data.azurerm_resource_group.fortihol.name
  virtual_network_name = azurerm_virtual_network.fortinac_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Internal Subnet (10.0.1.0/24)
resource "azurerm_subnet" "internal" {
  name                 = "internal-subnet"
  resource_group_name  = data.azurerm_resource_group.fortihol.name
  virtual_network_name = azurerm_virtual_network.fortinac_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP for FortiNAC Instances
resource "azurerm_public_ip" "fortinac_public_ip" {
  count               = 2
  name                = "iws-nac-ip-${count.index}"
  location            = data.azurerm_resource_group.fortihol.location
  resource_group_name = data.azurerm_resource_group.fortihol.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Management NIC (eth0)
resource "azurerm_network_interface" "fortinac_mgmt_nic" {
  count               = 2
  name                = "iws-nac-mgmt-${count.index}"
  location            = data.azurerm_resource_group.fortihol.location
  resource_group_name = data.azurerm_resource_group.fortihol.name

  ip_configuration {
    name                          = "mgmt-ipconfig"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.${count.index + 10}"
    public_ip_address_id          = azurerm_public_ip.fortinac_public_ip[count.index].id
  }
}

# Internal NIC (eth1)
resource "azurerm_network_interface" "fortinac_internal_nic" {
  count               = 2
  name                = "iws-nac-internal-${count.index}"
  location            = data.azurerm_resource_group.fortihol.location
  resource_group_name = data.azurerm_resource_group.fortihol.name

  ip_configuration {
    name                          = "internal-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.${count.index + 10}"
  }
}

# FortiNAC Virtual Machines (OS Disk Only)
resource "azurerm_linux_virtual_machine" "fortinac" {
  count               = 2
  name                = "iws-nac-${count.index}"
  location            = data.azurerm_resource_group.fortihol.location
  resource_group_name = data.azurerm_resource_group.fortihol.name
  size                = "Standard_D4s_v3"
  admin_username      = "iwsadmin"
  admin_password      = var.admin_password
  disable_password_authentication = false
  zone                = "1"

  network_interface_ids = [
    azurerm_network_interface.fortinac_mgmt_nic[count.index].id,
    azurerm_network_interface.fortinac_internal_nic[count.index].id
  ]

  source_image_reference {
    publisher = "fortinet"
    offer     = "fortinet_fortinac"
    sku       = "fortinet-fortinac"
    version   = "latest"
  }

  plan {
    name      = "fortinet-fortinac"
    publisher = "fortinet"
    product   = "fortinet_fortinac"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 60
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

# ✅ Create Persistent Storage Disk
resource "azurerm_managed_disk" "fortinac_data_disk" {
  count                = 2
  name                 = "iws-nac_DataDisk_${count.index}"
  location             = data.azurerm_resource_group.fortihol.location
  resource_group_name  = data.azurerm_resource_group.fortihol.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"  # ✅ Matches ARM Template
  disk_size_gb         = 512
  tier                 = "P20"  # ✅ Matches ARM Template
  zone                 = "1"
}

# ✅ Attach Persistent Data Disk to FortiNAC at LUN 0
resource "azurerm_virtual_machine_data_disk_attachment" "fortinac_disk_attach" {
  count              = 2
  managed_disk_id    = azurerm_managed_disk.fortinac_data_disk[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.fortinac[count.index].id
  lun                = 0  # ✅ FortiNAC expects the disk at LUN 0
  caching            = "ReadOnly"  # ✅ Matches ARM Template
}