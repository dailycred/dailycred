Rails.configuration.DAILYCRED_CLIENT_ID = "a9dbdd59-585b-4f60-81b9-e1ee6d333ec9"
Rails.configuration.DAILYCRED_SECRET_KEY = "08d7800d-2d7c-4338-87de-4eed77d1c9b2-9f367fe8-4e39-4edc-a8c7-1e759f657185"

dc_id = Rails.configuration.DAILYCRED_CLIENT_ID
dc_secret = Rails.configuration.DAILYCRED_SECRET_KEY

dc_options = { :client_options => {:site => "http://localhost:9000"} }

if File.exists?('/etc/ssl/certs')
  dc_options[:client_options][:ssl] = { :ca_path => '/etc/ssl/certs'}
end
if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt')
  dc_options[:client_options][:ssl] = { :ca_file => '/opt/local/share/curl/curl-ca-bundle.crt' }
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dailycred, dc_id, dc_secret, dc_options
end

Rails.application.config.middleware.use "Dailycred::Middleware", dc_id, :url => "http://localhost:9000"