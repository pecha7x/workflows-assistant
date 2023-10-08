module GmailService
  module AccessToken
    class Assign
      def self.run(gmail_configuration, token, refresh_token)
        new(gmail_configuration:, token:, refresh_token:).run
      end

      def initialize(gmail_configuration:, token:, refresh_token:)
        @gmail_configuration = gmail_configuration
        @token = token
        @api_refresh_token = refresh_token
      end

      def run
        gmail_configuration.update(api_refresh_token:)
        redis_field = RedisField.new("#{REDIS_KEY_SCOPE}:#{gmail_configuration.id}")
        redis_field.set_value(token, expires_in: 55.minutes) # the access token is expired on Google side in 1 hour, so we set it as 55 mins on our end
      end

      private

      attr_reader :gmail_configuration, :token, :api_refresh_token
    end
  end
end
