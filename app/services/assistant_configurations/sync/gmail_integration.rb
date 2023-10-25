module AssistantConfigurations
  module Sync
    class GmailIntegration < Base
      alias gmail_configuration assistant_configuration
      delegate :gmail_messages, :user_id, to: :gmail_configuration

      def run
        last_100_inbound_messages = GmailService::ApiClient.new(access_token).user_messages
        last_100_inbound_messages.each do |message_data|
          gmail_message = gmail_messages.find_or_initialize_by(external_id: message_data.id, user_id:)
          next if gmail_message.persisted? # skip duplicates

          message_attributes = AssistantConfiguration::Sync::Mapping::GmailMessage.new(message_data).build
          gmail_message.assign_attributes(message_attributes)
          if gmail_message.valid?
            gmail_message.save
            log('Gmail Message was imported')
          else
            log 'Failed to import an Gmail Message: ' \
                "errors: <#{gmail_message.errors.messages}>" \
                "attributes: <#{gmail_message.attributes}>; " \
                "params: <#{gmail_message.inspect}>; "
          end
        end
      end

      private

      def access_token
        @access_token ||= GmailService::AccessToken::Obtain.new(gmail_configuration:).run
      end
    end
  end
end
