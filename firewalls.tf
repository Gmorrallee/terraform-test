#data "azurerm_resource_group" "rg-platform-networking" {
#  name     = "RG-Platform-Networking"
#  provider = azurerm.sub-Platform
#}

resource "azurerm_firewall_policy" "fwp-cmlfwtest-01-uks" {
  name                = "FWP-CMLFWTest-01-UKS"
  resource_group_name = data.azurerm_resource_group.rg-platform-networking.name
  location            = data.azurerm_resource_group.rg-platform-networking.location
  provider            = azurerm.sub-Platform
  sku = "Standard"
  threat_intelligence_mode = "Alert"

  tags = {
    environment = "Platform"
    role     = "Firewall Policy "
  }

}

resource "azurerm_firewall_policy_rule_collection_group" "fwp-rcg-cmlfwtest-01-uks" {
  name                = "FWP-RCG-CMLFWTest-01-UKS"
  priority            = 100
    firewall_policy_id  = azurerm_firewall_policy.fwp-cmlfwtest-01-uks.id
  
}

resource "azurerm_firewall_policy_rule_collection_group" "fwp-rcg-cmlfwtest-01-uks-network-rules" {
  name                = "FWP-RCG-CMLFWTest-01-UKS-Network-Rules"
  priority            = 200
    firewall_policy_id  = azurerm_firewall_policy.fwp-cmlfwtest-01-uks.id
  
}

resource "azurerm_firewall_policy_rule_collection_group" "fwp-rcg-cmlfwtest-01-uks-dnat-rules" {
  name                = "FWP-RCG-CMLFWTest-01-UKS-NAT-Rules"
  priority            = 300
    firewall_policy_id  = azurerm_firewall_policy.fwp-cmlfwtest-01-uks.id
  
}

resource "azurerm_firewall_policy_rule_collection_group" "fwp-rcg-cmlfwtest-01-uks-application-rules" {
  name                = "FWP-RCG-CMLFWTest-01-UKS-Application-Rules"
  priority            = 400
    firewall_policy_id  = azurerm_firewall_policy.fwp-cmlfwtest-01-uks.id
  
}