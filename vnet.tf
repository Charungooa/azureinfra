provider "azurerm" {
  features {}

}

data "azurerm_resource_group" "existing_rgp" {
  name = var.resource-group
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "${var.vnetname}-vnet"
  location            = "${data.azurerm_resource_group.existing_rgp.location}"
  resource_group_name = "${data.azurerm_resource_group.existing_rgp.name}"
  address_space       = ["${var.address-space}"]
  # tags                = merge(var.tags, map("Name", format("%s-%s", "VNet", var.name)))
}

resource "azurerm_subnet" "subnet-vnet2" {
  for_each             = var.subnets
  name                 = each.key
  virtual_network_name = "${azurerm_virtual_network.vnet2.name}"
  resource_group_name  = "${data.azurerm_resource_group.existing_rgp.name}
  address_prefix       = each.value.addressPrefix
b}

resource "azurerm_network_security_group" "terraform_security" {
  name                = "terraform_nsg"
  location            = "${data.azurerm_resource_group.existing_rg.location}"
  resource_group_name = "${data.azurerm_resource_group.existing_rg.name}"
  #resource_group_name = azurerm_resource_group.example.name

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

# resource "azurerm_subnet_network_security_group_association" "example" {
#   subnet_id                 = "${azurerm_subnet.terrasubnet.id}"
#   network_security_group_id = "${azurerm_network_security_group.example.id}"
# }

# resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
#     network_interface_id = "${azurerm_network_interface.azterravnic.id}"
#     network_security_group_id = "${azurerm_network_security_group.terraform_security.id}"
# }



