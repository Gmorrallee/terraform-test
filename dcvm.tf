provider "azurerm" {
  alias           = "platform"
  subscription_id = var.subscription_platform
  features {}
}

data "azurerm_subnet" "sn-dirservices" {
  name                 = "SN-DirServices"
  virtual_network_name = azurerm_virtual_network.vnet-platform-01.name
  resource_group_name  = data.azurerm_resource_group.rg-platform-networking.name
  provider             = azurerm.sub-Platform
}

data "azurerm_resource_group" "rg-platform-dirservices" {
  name     = azurerm_resource_group.rg-platform-dirservices.name
  provider = azurerm.sub-Platform
}

resource "azurerm_network_interface" "cmlaz01dc01_nic" {
    name                = "CMLAZ01DC01-NIC"
    location            = data.azurerm_resource_group.rg-platform-dirservices.location
    resource_group_name = data.azurerm_resource_group.rg-platform-dirservices.name
    provider            = azurerm.sub-Platform

    ip_configuration {
        name                          = "internal"
        subnet_id                     = data.azurerm_subnet.sn-dirservices.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.101.10.5"
    }
    
}

resource "azurerm_windows_virtual_machine" "cmlaz01dc01_vm" {
    name = "CMLAZ01DC01"
    location = data.azurerm_resource_group.rg-platform-dirservices.location
    resource_group_name = data.azurerm_resource_group.rg-platform-dirservices.name
    network_interface_ids = [azurerm_network_interface.cmlaz01dc01_nic.id]
    size = "Standard_B2ms"
    provider = azurerm.platform
    admin_username = "IntercityAdmin"
    admin_password = var.admin_password
    computer_name  = "CMLAZ01DC01"  

    os_disk {
        name = "CMLAZ01DC01_OSDisk"
        storage_account_type = "Premium_LRS"
        caching = "ReadWrite"
    }
    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2025-Datacenter"
        version   = "latest"
    }
    tags = {
        environment = "Platform"
        role        = "Domain Controller"
    }
}