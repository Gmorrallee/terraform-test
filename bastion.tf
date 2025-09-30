data "azurerm_subnet" "bastionsubnet" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.vnet-platform-01.name
  resource_group_name  = data.azurerm_resource_group.rg-platform-networking.name
  provider             = azurerm.sub-Platform
}

resource "azurerm_public_ip" "pip-cml-bastion-01" {
  name                = "PIP-CML-Bastion-01"
  location            = data.azurerm_resource_group.rg-platform-networking.location
  resource_group_name = data.azurerm_resource_group.rg-platform-networking.name
  allocation_method   = "Static"
  sku                 = "Standard"
  provider            = azurerm.sub-Platform
  
}

#resource "azurerm_bastion_host" "cml-bastion-01" {
#  name                = "CML-Bastion-01"
#  location            = data.azurerm_resource_group.rg-platform-networking.location
#  resource_group_name = data.azurerm_resource_group.rg-platform-networking.name
#  sku                 = "Standard"
#  provider            = azurerm.sub-Platform

 # ip_configuration {
 #   name                 = "configuration"
 #   subnet_id            = data.azurerm_subnet.bastionsubnet.id
 #   public_ip_address_id = azurerm_public_ip.pip-cml-bastion-01.id
 # } 
#}