module AssistantConfigurations
  module Sync
    module Mapping
      class GmailMessage
        attr_reader :message_data

        def initialize(message_data)
          @message_data = message_data
        end

        def build
          return {} if payload.blank? || headers.blank?

          message_attributes
        end

        private

        def message_attributes
          {
            from: headers.find { |header| header.name == 'From' }&.value,
            short_body: message_data.snippet,
            raw_body: payload.parts&.to_json || '',
            created_at: headers.find { |header| header.name == 'Date' }&.value
          }.compact
        end

        def payload
          @payload ||= message_data.payload
        end

        def headers
          @headers ||= payload&.headers
        end
      end
    end
  end
end
