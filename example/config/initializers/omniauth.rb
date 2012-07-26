OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
Rails.application.config.middleware.use OmniAuth::Builder do
  provider 'dailycred', '9dbbaebe-bb11-44ef-bbdd-5e58645fab30', 'd987fc65-1097-43b6-9342-5e6efbbe558a-3428de34-a734-428b-9a19-d6af6c9eab50', {:client_options => {:ssl => {:ca_path => "/opt/local/etc/openssl/certs"}}}
end