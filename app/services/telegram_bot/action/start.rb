module TelegramBot
  module Action
    class Start < Base
      def run
        parsed_token_key = message.text[/^\/.*\s(.*)$/, 1]
        exists_token_parameters = TelegramBot::StartToken.pull_token_value!(parsed_token_key)
        if exists_token_parameters.nil?
          # TODO: perhaps we need to exit from bot also
          send_message('Sorry, but the link is expired or not valid')
        else
          object_parser_handler = TelegramBot::StartToken::Parameters::Handler.new(exists_token_parameters)
          object_parser_handler.run
          new_object = object_parser_handler.object
          new_object.t_me_chat_id = message.chat.id
          new_object.t_me_username = message.from.username
          new_object.save
        end
      end

      private

      def send_message(text)
        TelegramBot::Message::Sender.new(
          message_text: text,
          chat_id:      message.chat.id,
          parse_mode:   'HTML'
        ).run
      end
    end
  end  
end
