#cloud-config
tmos_declared:
  enabled: true
  icontrollx_trusted_sources: false
  icontrollx_package_urls:
    - "${DO_URL}"
    - "${AS3_URL}"
    - "${TS_URL}"
  do_declaration:
    schemaVersion: 1.0.0
    class: Device
    async: true
    label: Cloudinit Onboarding
    Common:
      admin:
        class: User
        shell: bash
        userType: regular
