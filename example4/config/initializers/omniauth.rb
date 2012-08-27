Rails.configuration.DAILYCRED_CLIENT_ID = "fb97a38f-2e09-4edc-a47e-ccd73ed52257"
Rails.configuration.DAILYCRED_SECRET_KEY = "b15f65c2-22f9-4ccc-bfd4-6f80cc7559a3-b3961bc1-0ad3-4608-9f45-4ad52a145b39"

dc_id = Rails.configuration.DAILYCRED_CLIENT_ID
dc_secret = Rails.configuration.DAILYCRED_SECRET_KEY

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :dailycred, dc_id, dc_secret
  #if you get an error like this: 
  # => SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed (OpenSSL::SSL::SSLError)
  #use this for OS X
  provider :dailycred, dc_id, dc_secret, {:client_options => {:ssl => {:ca_file => '/opt/local/share/curl/curl-ca-bundle.crt'}}}
  #or this for ubuntu
  #provider :dailycred, dc_id, dc_secret, {:client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}
end

Rails.configuration.middleware.use "Dailycred::Middleware", dc_id
