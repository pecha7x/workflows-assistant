module TelegramBot
  module Action
    class Base
      attr_reader :message

      def initialize(message:)
        @message = message
      end

      def run; end

      private

      def send_message_to_bot(text)
        TelegramBot::Message::Sender.new(
          message_text: text,
          chat_id: message.chat.id,
          parse_mode: 'HTML'
        ).run
      end
    end
  end
end
