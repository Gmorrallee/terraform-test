resource "azurerm_automation_account" "aa-cml-01" {
  name                = "AA-CML-01"
  location            = data.azurerm_resource_group.rg-platform-monitoring.location
  resource_group_name = data.azurerm_resource_group.rg-platform-monitoring.name
  sku_name            = "Basic"
  provider            = azurerm.sub-Platform

  tags = {
    environment = "Platform"
    role        = "Automation Account"
  }
  
}

resource "azurerm_automation_runbook" "rb-start-stop-vms" {
  name                    = "RB-Start-Stop-VMs"
  location                = data.azurerm_resource_group.rg-platform-monitoring.location
  resource_group_name     = data.azurerm_resource_group.rg-platform-monitoring.name
  automation_account_name = azurerm_automation_account.aa-cml-01.name
  log_verbose             = true
  log_progress            = true
  description             = "Runbook to start and stop VMs on a schedule"
  runbook_type            = "PowerShell"
  provider                = azurerm.sub-Platform

  tags = {
    environment = "Platform"
    role        = "Runbook"
  }

  publish_content_link {uri = "https://github.com/Gmorrallee/powershell/blob/main/VM-Disk-Snapshots/"}
}

resource "azurerm_automation_schedule" "sched-start-cmlaz01dc01" {
  name                    = "Sched-Start-CMLAZ01DC01"
  resource_group_name     = data.azurerm_resource_group.rg-platform-monitoring.name
  automation_account_name = azurerm_automation_account.aa-cml-01.name
  frequency               = "Week"
  interval                = 1
  start_time              = "2025-09-28T16:30:00Z"
  provider                = azurerm.sub-Platform
  
}