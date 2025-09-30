resource "azurerm_resource_group" "rg-platform-dirservices" {
  name     = "RG-Platform-DirServices"
  location = "uksouth"
  provider = azurerm.sub-Platform
}