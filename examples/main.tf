terraform {
  required_version = "~> 0.12.24"
  required_providers {
    azurerm = "~> 2.2.0"
  }
}

# create a random id
resource "random_id" "id" {
  byte_length = 2
}


# create the BIG-IPs
module bigip {
  source = "../"

  prefix              = format("%s-%s", var.prefix, random_id.id.hex)
  bigip_map           = local.bigip_map
  resource_group_name = azurerm_resource_group.main.name
  bigip_password      = random_password.bigippassword.result
}

locals {
  bigip_map = {
    "0" = {
      "network_interfaces" = {
        "0" = {
          "device_index"      = "0"
          "interface_type"    = "management"
          "private_ips_count" = 0
          "public_ip"         = true
          "subnet_id"         = azurerm_subnet.management.id
          "subnet_security_group_ids" = [
            null
          ]
        }
      }
    }
  }
}
