provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "existing_rgp" {
   name = var.resource-group
   location = "eastus"
}

# this is the resource block
resource "azurerm_virtual_network" "vnet2" {
  name                = "${var.vnetname}-vnet"
  location            = azurerm_resource_group.existing_rgp.location
  resource_group_name = azurerm_resource_group.existing_rgp.name
  address_space       = var.address-space
  # tags                = merge(var.tags, map("Name", format("%s-%s", "VNet", var.name)))
}

resource "azurerm_subnet" "subnet-vnet2" {
   virtual_network_name =   azurerm_virtual_network.vnet2.name
   address_prefixes =     ["10.0.0.0/24"]  
   name = "${var.vnetname}-subnet"
   resource_group_name =   data.azurerm_resource_group.existing_rgp.name  
}

resource "azurerm_network_security_group" "terraform_security" {
  name                = "terraform_nsg"
  location            = data.azurerm_resource_group.existing_rgp.location
  resource_group_name = data.azurerm_resource_group.existing_rgp.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowRDP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
