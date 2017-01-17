Scrivito.configure do |config|
  #
  # Uncomment following lines in order to explicitly set the tenant and the API key.
  # If not explicitly set, the tenant and the API key are obtained from the environment variables
  # SCRIVITO_TENANT and SCRIVITO_API_KEY.
  #
  config.tenant = ENV["SCRIVITO_TENANT"]
  config.api_key = ENV["SCRIVITO_API_KEY"]
  #

  # Disable the default routes to allow route configuration
  config.inject_preset_routes = false

  config.editing_auth do |env|
    SpreeScrivitoUser.to_scrivito_user(env["warden"].user)
  end

  config.find_user do |user_id|
    SpreeScrivitoUser.to_scrivito_user(Spree::User.find(user_id))
  end

end
