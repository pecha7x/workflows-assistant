module TelegramBot
  module Message
    class Handler
      TelegramBot::AVAILABLE_ACTIONS.each do |action_name|
        define_method "#{action_name}_action?" do
          parsed_action == action_name
        end
      end

      attr_reader :message, :chat_id, :username, :parsed_action, :response_text

      def initialize(message_data:)
        @message = Telegram::Bot::Types::Update.new(message_data).message
        @chat_id = message.chat.id
        @username = message.from.username
        @parsed_action = message.text[%r{^/(.*)\s}, 1]
      end

      def run
        if unavailable_command?
          @response_text = "Thank you, #{username}. But I understand only next commands: #{available_command_list} for now"
        else
          build_response_text
        end

        TelegramBot::Message::Sender.new(message_text: response_text, chat_id:, parse_mode: 'HTML').run

        "TelegramBot::Action::#{parsed_action.capitalize}".constantize.new(message:).run unless help_action?
      end

      private

      def build_response_text
        @response_text = send("response_text_on_#{parsed_action}")
      end

      def response_text_on_start
        "I'm starting..."
      end

      def response_text_on_stop
        "Okay, I'll stop.. Bye!"
      end

      def response_text_on_help
        text = "I'm <b>Workflow Bot</b> and related with #{APP_LINK}. "
        text += 'You should be the member there for usage.&#10;&#10;'
        text += "Please control me by <u>Notifier(s) Settings</u> at your account on #{APP_LINK}."
        text
      end

      def available_command_list
        TelegramBot::AVAILABLE_ACTIONS.map { |action| "/#{action}" }.join(', ')
      end

      def unavailable_command?
        TelegramBot::AVAILABLE_ACTIONS.exclude?(parsed_action)
      end
    end
  end
end
