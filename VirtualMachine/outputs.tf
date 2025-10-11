output "vms" {
  description = "Details of all created vms"
  value = {
    for k, v in azurerm_linux_viretual_machine.vm : k =>
    {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
    }
  }
}
