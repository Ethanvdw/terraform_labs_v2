resource "azurerm_virtual_network" "lab3" {
  name                = "lab3-network"
  location            = azurerm_resource_group.lab3.location
  resource_group_name = azurerm_resource_group.lab3.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "lab3" {
  name                 = "lab3-subnet"
  resource_group_name  = azurerm_resource_group.lab3.name
  virtual_network_name = azurerm_virtual_network.lab3.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_route_table" "lab3" {
  name                          = "lab3-routetable"
  location                      = azurerm_resource_group.lab3.location
  resource_group_name           = azurerm_resource_group.lab3.name
  disable_bgp_route_propagation = false

  route {
    name           = "local"
    address_prefix = "10.1.0.0/16"
    next_hop_type  = "VnetLocal"
  }

  route {
    name           = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_network_security_group" "lab3" {
  name                = "lab3-SecurityGroup"
  resource_group_name = azurerm_resource_group.lab3.name
  location            = azurerm_resource_group.lab3.location

  security_rule {
    name                       = "WebAdminNSG"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_ranges    = [3389]
    source_address_prefix      = "Internet"
  }
}

resource "azurerm_subnet_network_security_group_association" "lab3_nsg_assoc" {
  subnet_id                 = azurerm_subnet.lab3.id
  network_security_group_id = azurerm_network_security_group.lab3.id
}