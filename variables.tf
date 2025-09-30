variable "subscription_platform" {
  description = "Platform subscription ID"
  type        = string
  default = "3635cc97-a2d6-4bc1-9ea6-00fcddc10aa6"
}

variable "subscription_prod-01" {
  description = "Production subscription ID"
  type        = string
  default = "43d74b2b-f6c0-4c6b-9e12-1095e6955562"
}

variable "Vnet_location_platform" {
  description = "Location for all resources."
  type        = string
  default     = "uksouth"
}

  variable "rg_network_platform" {
  description = "Name of the Resource Group"    
  type        = string
  default  = "RG-Platform-Networking"
  
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  default     = "P@ssw0rd1234!"
  
}