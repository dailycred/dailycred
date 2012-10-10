Rails.configuration.DAILYCRED_CLIENT_ID = "4133a23f-b9c3-47e4-8989-cfb30510079d"
Rails.configuration.DAILYCRED_SECRET_KEY = "a1c21e72-98d8-47c2-9e9a-1e2dcd363b2f-f353b2af-1f51-416c-ad4c-59e70721dfab"

# configure where users should be redirected after authentication

Rails.configuration.DAILYCRED_OPTIONS = {
  :client_options => {
    :site => 'http://ec2-72-44-40-55.compute-1.amazonaws.com:9000',
    :verbose => true
  }
  # :after_auth => '/hello', #after login
  # :after_unauth => '/goodbye' #after logout
}
