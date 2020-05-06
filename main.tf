data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# deploy BIG-IP virtual machine
# Create F5 BIGIP VMs 
resource "azurerm_linux_virtual_machine" "f5bigip" {
  name                  = format("%s-bigip", var.prefix)
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.mgmt-nic.id]
  size                  = var.instance_type
  #   zone                            = element(local.azs, count.index % length(local.azs))
  admin_username                  = "azureuser"
  admin_password                  = var.bigip_password
  disable_password_authentication = false


  # leave commented out until 15.1 is in the marketplace
  source_image_reference {
    publisher = "f5-networks"
    offer     = var.product
    sku       = var.image_name
    version   = var.bigip_version
  }
  # leave commented out until 15.1 is in the marketplace
  plan {
    name      = var.image_name
    publisher = "f5-networks"
    product   = var.product
  }
  # this is needed to reference the shared image
  # remove when 15.1 is in the marketplace
  #source_image_id = var.image_id

  os_disk {
    name                 = format("%s-bigip-osdisk", var.prefix)
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "80"
  }

  custom_data = base64encode(data.template_file.vm_onboard.rendered)

  tags = {
    Name = format("%s-bigip", var.prefix)
    # environment = var.specification[var.specification_name]["environment"]
    workload = "ltm"
  }
}

# Create public IPs for BIG-IP management UI
resource "azurerm_public_ip" "management_public_ip" {
  name                = format("%s-bigip", var.prefix)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"   # Static is required due to the use of the Standard sku
  sku                 = "Standard" # the Standard sku is required due to the use of availability zones
  #   zones               = [element(local.azs, count.index)]

  #   tags = {
  #     environment = var.specification[terraform.workspace]["environment"]
  #   }
}

# create interfaces for BIG-IPs
resource "azurerm_network_interface" "mgmt-nic" {
  name                = format("%s-mgmtnic", var.prefix)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.bigip_map[0].network_interfaces[0].subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.management_public_ip.id
  }

  tags = {
    Name = format("%s-mgmtnic", var.prefix)
    # environment = var.specification[var.specification_name]["environment"]
  }
}

resource "azurerm_network_interface_security_group_association" "mgmt-nic-security" {
  network_interface_id      = azurerm_network_interface.mgmt-nic.id
  network_security_group_id = var.bigip_map[0].network_interfaces[0].subnet_security_group_ids[0]
}

# Setup Onboarding scripts
data "template_file" "vm_onboard" {
  template = "${file("${path.module}/custom_data.tpl")}"
}

