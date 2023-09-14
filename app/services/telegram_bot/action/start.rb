module TelegramBot
  module Action
    class Start < Base
      attr_reader :parsed_object

      def run
        parsed_token_key = message.text[%r{^/.*\s(.*)$}, 1]
        exists_token_parameters = TelegramBot::StartToken.pull_token_value(parsed_token_key)
        if exists_token_parameters.nil?
          send_message_to_bot("Sorry, but the link is expired or not valid. Try to refresh this on #{APP_LINK}.")
        else
          object_parser_handler = TelegramBot::StartToken::Parameters::Handler.new(exists_token_parameters)
          object_parser_handler.run
          @parsed_object = object_parser_handler.object

          if parsed_object.telegram_username == message.from.username
            start_bot
          else
            send_invalid_username_message
          end
        end
      end

      private

      def start_bot
        parsed_object.telegram_bot_start!(message.chat.id)
        send_message_to_bot("Great news! #{parsed_object.class.name.titleize} <b>'#{parsed_object.name}'</b> has been successfully configured.")
      end

      def send_invalid_username_message
        send_message_to_bot(
          "Sorry <b>#{message.from.username}</b>,&#10;
          but #{parsed_object.class.name.titleize} <u>'#{parsed_object.name}'</u> has another member.&#10;
          The member's username - <b>#{parsed_object.telegram_username}</b>."
        )
      end
    end
  end
end
