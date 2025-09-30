
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

resource "azurerm_firewall_policy_rule_collection_group" "fwp-rcg-cmlfwtest-netrules-01-uks" {
  name                = "FWP-RCG-CMLFWTest-01-UKS-NetworkRules"
  priority            = 100
    firewall_policy_id  = azurerm_firewall_policy.fwp-cmlfwtest-01-uks.id

  network_rule_collection {
    name     = "Windows-Activation-Rules"
    priority = 101
    action   = "Allow"

    rule {
      name                  = "Windows-Activation"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["kms.core.windows.net"]
      destination_ports     = ["1688"]    
  }
}

 network_rule_collection {
  name = "DNS-Rules"
  priority = 102
  action = "Allow"

  rule {
    name = "Azure-DNS"
     protocols              = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["168.63.129.16"]
      destination_ports     = ["53"] 
  } 
  rule {
    name = "GoogleDNS"
    protocols             = ["TCP"]
    source_addresses      = ["*"]
    destination_addresses = ["8.8.8.8,8.8.4.4"]
      destination_ports     = ["53"] 
  }
  rule {
    name = "Cloudflare-DNS"
         protocols            = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["1.1.1.1,1.0.0.1"]
      destination_ports     = ["53"] 
  }
 }
 }

resource "azurerm_firewall_policy_rule_collection_group" "fwp-rcg-cmlfwtest-applicationsrules-01-uks" {
  name                = "FWP-RCG-CMLFWTest-01-UKS-ApplicationRules"
  priority            = 200
    firewall_policy_id  = azurerm_firewall_policy.fwp-cmlfwtest-01-uks.id
  
}
