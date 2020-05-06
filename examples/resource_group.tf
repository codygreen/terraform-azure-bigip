locals {
  cidr = var.specification[terraform.workspace]["cidr"]
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  byte_length = 2
}

# Create a resource group 
resource "azurerm_resource_group" "main" {
  name     = format("%s-resourcegroup-%s", var.prefix, random_id.randomId.hex)
  location = var.specification[terraform.workspace]["region"]

  tags = {
    environment = var.specification[terraform.workspace]["environment"]
  }
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = format("diagstorage%s", random_id.randomId.hex)
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.specification[terraform.workspace]["environment"]
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "bigip" {
  name                = format("%s-securitygroup-%s", var.prefix, random_id.randomId.hex)
  location            = var.specification[terraform.workspace]["region"]
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS-8443"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.specification[terraform.workspace]["environment"]
  }
}

# Create virtual network
resource "azurerm_virtual_network" "main" {
  name                = format("%s-vnet-%s", var.prefix, random_id.randomId.hex)
  address_space       = [local.cidr]
  location            = var.specification[terraform.workspace]["region"]
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = var.specification[terraform.workspace]["environment"]
  }
}

# Create management subnet
resource "azurerm_subnet" "management" {
  name                 = format("%s-managementsubnet-%s", var.prefix, random_id.randomId.hex)
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  # address prefix 10.1x.0.0/24
  address_prefix = cidrsubnet(local.cidr, 8, 0)
}
