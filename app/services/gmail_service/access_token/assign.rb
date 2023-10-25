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
        gmail_configuration.update(api_refresh_token:, gmail_user_email:)
        redis_field = RedisField.new("#{REDIS_KEY_SCOPE}:#{gmail_configuration.id}")
        # the access token is expired on Google side in 1 hour, so we set it as 55 mins on our end
        redis_field.set_value(token, expires_in: 55.minutes)
      end

      private

      def gmail_user_email
        user_profile = GmailService::ApiClient.new(token).user_profile
        user_profile&.email_address
      end

      attr_reader :gmail_configuration, :token, :api_refresh_token
    end
  end
end
