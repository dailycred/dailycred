Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dailycred, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end
