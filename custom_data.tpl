#cloud-config
tmos_declared:
  enabled: true
  icontrollx_trusted_sources: false
  icontrollx_package_urls:
    - "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.12.0/f5-declarative-onboarding-1.12.0-1.noarch.rpm"
    - "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.19.0/f5-appsvcs-3.19.0-4.noarch.rpm"
    - "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.11.0/f5-telemetry-1.11.0-1.noarch.rpm"