resource "azurerm_network_interface" "lab3" {
  name                = "lab3-nic"
  location            = azurerm_resource_group.lab3.location
  resource_group_name = azurerm_resource_group.lab3.name

  ip_configuration {
    name                          = "lab3_ip"
    subnet_id                     = azurerm_subnet.lab3.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab3publicpip.id
  }
}



resource "azurerm_windows_virtual_machine" "lab3" {
  name                = "VM3"
  resource_group_name = azurerm_resource_group.lab3.name
  location            = azurerm_resource_group.lab3.location
  size                = "Standard_B2S"
  # size                = "Standard_DS2_v2"
  admin_username = "TFadminuser"
  admin_password = "TFP@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.lab3.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    #   sku       = "2016-Datacenter"
    version = "latest"
  }
  #  tags = {
  #    Lab-edit = "FirstChange"
  #    Lab-edit = "SecondChange"
  #  }
}

resource "azurerm_public_ip" "lab3publicpip" {
  name                    = "lab3-pip"
  location                = azurerm_resource_group.lab3.location
  resource_group_name     = azurerm_resource_group.lab3.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

}
