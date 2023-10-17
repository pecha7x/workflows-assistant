module AssistantConfigurations
  module Sync
    class GmailIntegration < Base
      alias gmail_configuration assistant_configuration
      delegate :gmail_messages, to: :gmail_configuration

      def run
        last_100_inbound_messages = GmailService::ApiClient.new(access_token).user_messages
        last_100_inbound_messages.messages.each do |message_data|
          gmail_message = gmail_messages.find_or_initialize_by(external_id: message_data.id)
          next if gmail_message.persisted? # skip duplicates
        end
      end

      private

      def access_token
        @access_token ||= GmailService::AccessToken::Obtain.new(gmail_configuration:).run
      end
    end
  end
end
