Rails.configuration.DAILYCRED_CLIENT_ID = "b0538e1c-fc6b-43b2-a799-dd9576161847"
Rails.configuration.DAILYCRED_SECRET_KEY = "942b98e8-415e-4a48-b1b6-e9030efcb94b-bf5df849-eaa5-46a6-9388-7e88fb0ef538"

dc_id = Rails.configuration.DAILYCRED_CLIENT_ID
dc_secret = Rails.configuration.DAILYCRED_SECRET_KEY

dc_options = { :client_options => {} }

if File.exists?('/etc/ssl/certs')
  dc_options[:client_options][:ssl] = { :ca_path => '/etc/ssl/certs'}
end
if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt')
  dc_options[:client_options][:ssl] = { :ca_file => '/opt/local/share/curl/curl-ca-bundle.crt' }
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dailycred, dc_id, dc_secret, dc_options
end

Rails.configuration.dc_options = dc_options

Rails.application.config.middleware.use "Dailycred::Middleware", dc_id