variable prefix {
  description = "Prefix for resources created by this module"
  type        = string
  default     = "terraform-aws-bigip-demo"
}

variable instance_type {
  description = "virtual machine instance type"
  type        = string
  default     = "Standard_DS3_v2"
}

variable image_name {
  description = "BIG-IP Marketplace Image name"
  type        = string
  default     = "f5-bigip-virtual-edition-25m-best-hourly"
}

variable product {
  description = "BIG-IP Marketplace Product name"
  type        = string
  default     = "f5-big-ip-best"
}

variable bigip_version {
  description = "BIG-IP Marketplace version"
  type        = string
  default     = "15.1.002000"
}

variable bigip_map {
  description = "map of network subnet ids to BIG-IP interface ids"
  type = map(object({
    network_interfaces = map(object({
      subnet_id                 = string
      subnet_security_group_ids = list(string)
      interface_type            = string
      public_ip                 = bool
      private_ips_count         = number
      device_index              = number
    }))
  }))
}

## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/releases
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable DO_URL {
  description = "URL to download the BIG-IP Declarative Onboarding module"
  type        = string
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.12.0/f5-declarative-onboarding-1.12.0-1.noarch.rpm"
}
## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable AS3_URL {
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.19.0/f5-appsvcs-3.19.0-4.noarch.rpm"
}

## Please check and update the latest TS URL from https://github.com/F5Networks/f5-telemetry-streaming/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable TS_URL {
  description = "URL to download the BIG-IP Telemetry Streaming module"
  type        = string
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.11.0/f5-telemetry-1.11.0-1.noarch.rpm"
}

## Please check and update the latest Failover Extension URL from https://github.com/f5devcentral/f5-cloud-failover-extension/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable CFE_URL {
  description = "URL to download the BIG-IP Cloud Failover Extension module"
  type        = string
  default     = "https://github.com/f5devcentral/f5-cloud-failover-extension/releases/download/v1.1.0/f5-cloud-failover-1.1.0-0.noarch.rpm"
}

variable custom_user_data {
  description = "Provide a custom bash script or cloud-init script the BIG-IP will run on creation"
  type        = string
  default     = null
}

variable resource_group_name {
  description = "Azure Resource Group Name for this deployment"
  type        = string
  default     = null
}

variable bigip_password {
  description = "BIG-IP Admin password"
  type        = string
}
