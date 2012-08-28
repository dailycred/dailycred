Rails.configuration.DAILYCRED_CLIENT_ID = "<%= client_id %>"
Rails.configuration.DAILYCRED_SECRET_KEY = "<%= secret_key %>"

dc_id = Rails.configuration.DAILYCRED_CLIENT_ID
dc_secret = Rails.configuration.DAILYCRED_SECRET_KEY

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dailycred, dc_id, dc_secret
  #if you get an error like this: 
  # => SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed (OpenSSL::SSL::SSLError)
  
  #use this for OS X
  #provider :dailycred, dc_id, dc_secret, {:client_options => {:ssl => {:ca_file => '/opt/local/share/curl/curl-ca-bundle.crt'}}}

  #or this for ubuntu
  #provider :dailycred, dc_id, dc_secret, {:client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}

  #if you still get the SSL error, look here for help: http://martinottenwaelter.fr/2010/12/ruby19-and-the-ssl-error
end

Rails.application.config.middleware.use "Dailycred::Middleware", dc_id