output "fortinac_public_ip" {
  value = try(jsondecode(azurerm_resource_group_template_deployment.fortinac.output_content)["publicIp"], "No IP Found")
}

output "virtual_machine_id" {
  value = try(jsondecode(azurerm_resource_group_template_deployment.fortinac.output_content)["virtualMachineId"], "No VM ID Found")
}
