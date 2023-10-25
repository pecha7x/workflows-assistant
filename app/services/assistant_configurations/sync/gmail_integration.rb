module AssistantConfigurations
  module Sync
    class GmailIntegration < Base
      alias gmail_configuration assistant_configuration
      delegate :gmail_messages, :user_id, to: :gmail_configuration

      attr_reader :api_client

      def initialize(assistant_configuration_id)
        super
        @api_client = GmailService::ApiClient.new(access_token)
      end

      def run
        api_client.user_messages.each do |message_data|
          gmail_message = gmail_messages.find_or_initialize_by(external_id: message_data.id, user_id:)
          next if gmail_message.persisted? # skip duplicates

          process_message(message_data.id)
        end
      end

      private

      def process_message(id)
        message_data = api_client.user_message(id)
        return unless message_data

        message_attributes = AssistantConfigurations::Sync::Mapping::GmailMessage.new(message_data).build
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

      def access_token
        @access_token ||= GmailService::AccessToken::Obtain.new(gmail_configuration:).run
      end
    end
  end
end
