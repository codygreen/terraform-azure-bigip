# copyright: 2018, The Authors

title "BIG-IP Azure Deployment"

control "Connectivity" do
  impact 1.0
  title "BIGIP is reachable"
  # can we reach the management port on the BIG-IP?
  describe host(input('bigip_host'), port: input('bigip_port'), protocol: 'tcp') do
      it { should be_reachable }
  end
end 

control "Declarative Onboarding Available" do
  impact 1.0
  title "BIGIP has DO"
  # is the declarative onboarding end point available?
  describe http("https://#{input('bigip_host')}:#{input('bigip_port')}/mgmt/shared/declarative-onboarding/info",
            auth: {user: 'admin', pass: input('bigip_password')},
            params: {format: 'html'},
            method: 'GET',
            ssl_verify: false) do
        its('status') { should cmp 200 }
        its('headers.Content-Type') { should match 'application/json' }
  end
  describe json(content: http("https://#{input('bigip_host')}:#{input('bigip_port')}/mgmt/shared/declarative-onboarding/info",
            auth: {user: 'admin', pass: input('bigip_password')},
            params: {format: 'html'},
            method: 'GET',
            ssl_verify: false).body) do
        its([0,'version']) { should eq '1.12.0' }
        its([0,'release']) { should eq '1' } # this should be replaced with a test using the json resource
  end
end 

control "Application Services Available" do
  impact 1.0
  title "BIGIP has AS3"
  # is the application services end point available?
  describe http("https://#{input('bigip_host')}:#{input('bigip_port')}/mgmt/shared/appsvcs/info",
            auth: {user: 'admin', pass: input('bigip_password')},
            params: {format: 'html'},
            method: 'GET',
            ssl_verify: false) do
        its('status') { should cmp 200 }
        its('headers.Content-Type') { should match 'application/json' }
  end
  describe json(content: http("https://#{input('bigip_host')}:#{input('bigip_port')}/mgmt/shared/appsvcs/info",
            auth: {user: 'admin', pass: input('bigip_password')},
            params: {format: 'html'},
            method: 'GET',
            ssl_verify: false).body) do
        its('version') { should eq '3.19.0' }
        its('release') { should eq '4' } # this should be replaced with a test using the json resource
  end
end 

control "Telemetry Streaming Available" do
  impact 1.0
  title "BIGIP has TS"
  # is the telemetry streaming end point available?
  describe http("https://#{input('bigip_host')}:#{input('bigip_port')}/mgmt/shared/telemetry/info",
            auth: {user: 'admin', pass: input('bigip_password')},
            params: {format: 'html'},
            method: 'GET',
            ssl_verify: false) do
        its('status') { should cmp 200 }
        its('headers.Content-Type') { should match 'application/json' }
  end
  describe json(content: http("https://#{input('bigip_host')}:#{input('bigip_port')}/mgmt/shared/telemetry/info",
            auth: {user: 'admin', pass: input('bigip_password')},
            params: {format: 'html'},
            method: 'GET',
            ssl_verify: false).body) do
        its('version') { should eq '1.11.0' }
        its('release') { should eq '1' } # this should be replaced with a test using the json resource
  end
end 