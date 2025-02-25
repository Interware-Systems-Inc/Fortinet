provider "azurerm" {
  features {}

  subscription_id = "f7546bbb-ea74-4dc8-ba34-b2f392209edf"
}

# Deploy FortiNAC Using ARM Template
resource "azurerm_resource_group_template_deployment" "fortinac" {
  name                = "FortiNACDeployment"
  resource_group_name = "FortiHoL"  # Directly referencing existing RG
  deployment_mode     = "Incremental"

  template_content = file("${path.module}/deployment.json")

  parameters_content = jsonencode({
    location                 = { value = var.location }
    publicIpAddressName      = { value = var.public_ip_name }
    publicIpAddressSku       = { value = "Standard" }
    publicIpAddressType      = { value = "Static" }
    pipDeleteOption          = { value = "Delete" }
    virtualMachineName       = { value = var.vm_name }
    virtualMachineComputerName = { value = var.vm_name }
    virtualMachineRG         = { value = "FortiHoL" }  # Directly referencing existing RG
    virtualMachineSize       = { value = var.vm_size }
    adminUsername            = { value = var.admin_username }
    adminPassword            = { value = var.admin_password }
    networkInterfaceName     = { value = var.network_interface_name }
    networkSecurityGroupName = { value = var.network_security_group_name }
    virtualNetworkName       = { value = var.virtual_network_name }
    subnetName               = { value = var.subnet_name }
    osDiskType               = { value = "StandardSSD_LRS" }
    osDiskSizeGiB            = { value = 1024 }
    nicDeleteOption          = { value = "Delete" }
    osDiskDeleteOption       = { value = "Delete" }
    enablePeriodicAssessment = { value = "ImageDefault" }
    imageReferencePublisher  = { value = var.imageReferencePublisher }
    imageReferenceOffer      = { value = var.imageReferenceOffer }
    imageReferenceSku        = { value = var.imageReferenceSku }
    imageReferenceVersion    = { value = var.imageReferenceVersion }
  })
}
