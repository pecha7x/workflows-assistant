module GmailService
  module AccessToken
    class Obtain
      def self.run(gmail_configuration)
        new(gmail_configuration:).run
      end

      def initialize(gmail_configuration:)
        @gmail_configuration = gmail_configuration
        @existing_value = RedisField.new("#{REDIS_KEY_SCOPE}:#{gmail_configuration.id}").value
      end

      def run
        existing_value || refresh_value
      end

      private

      attr_reader :gmail_configuration, :existing_value
      delegate :api_refresh_token, to: :gmail_configuration

      def refresh_value
        client = GoogleApiClient.new
        new_value = client.fetch_access_token!(api_refresh_token)
        GmailService::AccessToken::Assign.run(gmail_configuration, new_value, api_refresh_token) if new_value

        new_value
      end
    end
  end
end
