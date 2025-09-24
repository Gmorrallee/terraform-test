
data "azurerm_resource_group" "rg-platform-networking" {
  name     = "RG-Platform-Networking"
  provider = azurerm.sub-Platform
}

data "azurerm_resource_group" "rg-prod-01-networking" {
  name     = "RG-Prod-01-Networking"
  provider = azurerm.sub-Prod-01
  
}

data "azurerm_resource_group" "rg-platform-monitoring" {
  name     = "RG-Platform-Monitoring"
  provider = azurerm.sub-Platform
  
}

resource "azurerm_virtual_network" "vnet-platform-01" {
  name                = "AZ01-Platform-01"
  address_space       = ["10.101.0.0/16"]
  location            = data.azurerm_resource_group.rg-platform-networking.location
  resource_group_name = data.azurerm_resource_group.rg-platform-networking.name
  provider            = azurerm.sub-Platform
}

resource "azurerm_subnet" "SN_BastionSubnet" {
  name                 = "SN-BastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg-platform-networking.name
  virtual_network_name = azurerm_virtual_network.vnet-platform-01.name  
  address_prefixes     = ["10.101.250.0/24"]
  provider             = azurerm.sub-Platform
  
}

resource "azurerm_subnet" "SN_AzureFirewallSubnet" {
  name                 = "SN-AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.rg-platform-networking.name
  virtual_network_name = azurerm_virtual_network.vnet-platform-01.name    
  address_prefixes     = ["10.101.251.0/24"]
  provider             = azurerm.sub-Platform
  
}

resource "azurerm_virtual_network" "vnet-prod-01" {
  name                = "AZ01-Prod-01"
  address_space       = ["10.102.0.0/16"]
  location            = data.azurerm_resource_group.rg-prod-01-networking.location
  resource_group_name = data.azurerm_resource_group.rg-prod-01-networking.name
  provider            = azurerm.sub-Prod-01 
}

resource "azurerm_subnet" "SN-DirServices" {
  name                 = "SN-DirServices"
  resource_group_name  = data.azurerm_resource_group.rg-prod-01-networking.name
  virtual_network_name = azurerm_virtual_network.vnet-prod-01.name  
  address_prefixes     = ["10.102.10.0/23"]
  provider             = azurerm.sub-Prod-01
}

resource "azurerm_subnet" "SN-AppServices" {
  name                 = "SN-AppServices"
  resource_group_name  = data.azurerm_resource_group.rg-prod-01-networking.name
  virtual_network_name = azurerm_virtual_network.vnet-prod-01.name    
  address_prefixes     = ["10.102.100.0/23"]
  provider             = azurerm.sub-Prod-01
  }

resource "azurerm_virtual_network_peering" "peer-platform-prod" {
  name                      = "Peer-AZ01-Platform-AZ01-Prod-01"
  resource_group_name       = data.azurerm_resource_group.rg-platform-networking.name
  virtual_network_name      = azurerm_virtual_network.vnet-platform-01.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-prod-01.id
  allow_forwarded_traffic   = true
  provider                 = azurerm.sub-Platform
  
}
resource "azurerm_virtual_network_peering" "peer-prod-platform" {
  name                      = "Peer-AZ01-Prod-01-AZ01-Platform"
  resource_group_name       = data.azurerm_resource_group.rg-prod-01-networking.name
  virtual_network_name      = azurerm_virtual_network.vnet-prod-01.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-platform-01.id
  allow_forwarded_traffic   = true
  provider                  = azurerm.sub-Prod-01
}

resource "azurerm_network_security_group" "nsg_prod-01-dirservices" {
  name                = "NSG-Prod-01-DirServices"
  location            = data.azurerm_resource_group.rg-prod-01-networking.location
  resource_group_name = data.azurerm_resource_group.rg-prod-01-networking.name
  provider            = azurerm.sub-Prod-01
}

resource "azurerm_network_security_rule" "nsg_prod-01_dirservices_denyall" {
  name                        = "Deny-Any-All"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg-prod-01-networking.name
  network_security_group_name = azurerm_network_security_group.nsg_prod-01-dirservices.name
  provider                    = azurerm.sub-Prod-01
  
}

resource "azurerm_network_security_rule" "nsg_prod-01_dirservices_allowbastion" {
  name                        = "Allow-Bastion"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "10.101.250.0/24"
  destination_address_prefix  = "10.102.10.0/23"
  resource_group_name         = data.azurerm_resource_group.rg-prod-01-networking.name
  network_security_group_name = azurerm_network_security_group.nsg_prod-01-dirservices.name
  provider                    = azurerm.sub-Prod-01
  
}

resource "azurerm_network_security_group" "nsg_prod-01-appservices" {
  name                = "NSG-Prod-01-AppServices"
  location            = data.azurerm_resource_group.rg-prod-01-networking.location
  resource_group_name = data.azurerm_resource_group.rg-prod-01-networking.name
  provider            = azurerm.sub-Prod-01  
}

resource "azurerm_network_security_rule" "nsg_prod_01_appservices_denyall" {
  name                        = "Deny-Any-All"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg-prod-01-networking.name
  network_security_group_name = azurerm_network_security_group.nsg_prod-01-appservices.name
  provider                    = azurerm.sub-Prod-01
  
}

resource  "azurerm_network_security_rule" "nsg_prod_01_appservices_allowbastion" {
  name                        = "Allow-Bastion"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "10.101.250.0/24"
  destination_address_prefix  = "10.102.100.0/23"
  resource_group_name         = data.azurerm_resource_group.rg-prod-01-networking.name
  network_security_group_name = azurerm_network_security_group.nsg_prod-01-appservices.name
  provider                    = azurerm.sub-Prod-01
  
}

resource "azurerm_subnet_network_security_group_association" "assoc-nsg-dirservices" {
  subnet_id                 = azurerm_subnet.SN-DirServices.id
  network_security_group_id = azurerm_network_security_group.nsg_prod-01-dirservices.id
  provider                  = azurerm.sub-Prod-01  
}   

resource "azurerm_subnet_network_security_group_association" "assoc-nsg-appservices" {
  subnet_id                 = azurerm_subnet.SN-AppServices.id
  network_security_group_id = azurerm_network_security_group.nsg_prod-01-appservices.id
  provider                  = azurerm.sub-Prod-01  
}

resource "azurerm_log_analytics_workspace" "law-cml" {
  name                = "LAW-CML"
  location            = data.azurerm_resource_group.rg-platform-monitoring.location
  resource_group_name = data.azurerm_resource_group.rg-platform-monitoring.name
  sku                 = "PerGB2018"
  retention_in_days  = 30
  provider            = azurerm.sub-Platform
}