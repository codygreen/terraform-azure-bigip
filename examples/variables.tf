variable specification {
  default = {
    default = {
      number_public_interfaces  = 0
      number_private_interfaces = 0
      instance_type             = "Standard_DS3_v2"
      region                    = "eastus"
      cidr                      = "10.0.0.0/16"
      environment               = "1nic"
    }
  }
}

variable prefix {
  description = "Prefix for resources created by this module"
  type        = string
  default     = "tf-azure-bigip-example"
}
