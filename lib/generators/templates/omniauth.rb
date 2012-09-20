Rails.configuration.DAILYCRED_CLIENT_ID = "YOUR_CLIENT_ID"
Rails.configuration.DAILYCRED_SECRET_KEY = "YOUR_SECRET_KEY"

dc_id = Rails.configuration.DAILYCRED_CLIENT_ID
dc_secret = Rails.configuration.DAILYCRED_SECRET_KEY

dc_options = { :client_options => {
        :site => "https://www.dailycred.com",
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/access_token'
      } }

if File.exists?('/etc/ssl/certs')
  dc_options[:client_options][:ssl] = { :ca_path => '/etc/ssl/certs'}
end
if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt')
  dc_options[:client_options][:ssl] = { :ca_file => '/opt/local/share/curl/curl-ca-bundle.crt' }
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dailycred, dc_id, dc_secret, dc_options
end

Rails.application.config.middleware.use "Dailycred::Middleware", dc_id