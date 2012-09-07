Rails.configuration.DAILYCRED_CLIENT_ID = "ecafb79f-a198-4dbd-82d4-f921d49c6721"
Rails.configuration.DAILYCRED_SECRET_KEY = "50a3ff88-409c-47e8-8afa-9ba5f52f7c15-d870ef5a-67d6-4c7e-8468-b77b2f08447a"

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