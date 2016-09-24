Rails.application.config.middleware.use OmniAuth::Builder do
  provider :bike_index, 
           Rails.application.secrets.omniauth_provider_key, Rails.application.secrets.omniauth_provider_secret,
           scope: 'read_user read_bikes' 
end
