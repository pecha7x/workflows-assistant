redis_config = { 
  url:                 Rails.application.credentials.redis_url,
  reconnect_attempts:  15
}

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
