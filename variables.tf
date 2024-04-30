variable "resource-group" {
  type        = string
  description = "The name of the resource group in which to create the virtual network."
}


variable "vnetname" {
  type        = string
  description = "Name for the Virtual Network (VNet) that will be created."
  default     = "" # Must be provided by calling script.
}

variable "address-space" {
  type        = list(string)
  description = "A list of address prefixes for this VNet, each expressed as a CIDR notation string."
}
