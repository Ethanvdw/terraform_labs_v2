resource "azurerm_network_interface" "nic" {
  for_each = tomap({
    "VM1" = "nic-vm1"
    "VM2" = "nic-vm2"
  })
  name                = each.value
  location            = azurerm_resource_group.resgrp.location
  resource_group_name = azurerm_resource_group.resgrp.name

  ip_configuration {
    name                          = "${each.key}-ipconfig"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-asscociations" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "nic-ipconfig-${count.index}"
  backend_address_pool_id = tolist(azurerm_application_gateway.appgtw.backend_address_pool).0.id
}

resource "random_password" "password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "azurerm_windows_virtual_machine" "virtual-machines" {
  count               = 2
  name                = "VM-${count.index}"
  resource_group_name = azurerm_resource_group.resgrp.name
  location            = azurerm_resource_group.resgrp.location
  size                = var.VM_SIZE
  admin_username      = "azureadmin"
  admin_password      = random_password.password.result

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "vm-extensions" {
  count                = 2
  name                 = "vm${count.index}-ext"
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual-machines[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS
}