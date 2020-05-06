#!/bin/bash
bigip_mgmt_ip=$(terraform output --json | jq '.bigip_mgmt_ip.value' -r)
bigip_password=$(terraform output --json | jq '.bigip_password.value' -r)
inspec exec inspec/bigip --input bigip_host=$bigip_mgmt_ip bigip_password=$bigip_password bigip_port=8443