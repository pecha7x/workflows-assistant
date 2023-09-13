module TelegramBot
  module StartToken
    REDIS_KEY_SCOPE = 'telegram:start:token'.freeze

    def self.generate_token(object, expires_in: nil)
      parameters = TelegramBot::StartToken::Parameters::Builder.new(object).values
      token = Digest::SHA1.hexdigest([Time.current, rand(111..999), parameters].join) # just a maximum random string
      redis_field = RedisField.new("#{REDIS_KEY_SCOPE}:#{token}")
      redis_field.set_value(parameters.to_json, expires_in:)

      token
    end

    def self.pull_token_value(token_key)
      return nil if token_key.blank?

      redis_field = RedisField.new("#{REDIS_KEY_SCOPE}:#{token_key}")
      return nil unless redis_field.exists?

      parameters = redis_field.value
      redis_field.delete

      parameters
    end
  end
end
