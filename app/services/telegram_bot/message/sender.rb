module TelegramBot
  module Message
    class Sender
      PARSE_MODE_OPTIONS = %w[HTML MarkdownV2 Markdown].freeze # https://core.telegram.org/bots/api#formatting-options

      attr_reader :bot, :message_text, :chat_id, :parse_mode
      alias text message_text

      def initialize(message_text:, chat_id:, parse_mode:)
        raise "#{parse_mode} is not allowed parse_mode" if PARSE_MODE_OPTIONS.exclude?(parse_mode)

        @bot = Telegram::Bot::Api.new(Rails.application.credentials.telegram.bot.token)
        @message_text = message_text
        @chat_id = chat_id
        @parse_mode = parse_mode
      end

      def run
        bot.send_message(chat_id:, text:, parse_mode:)
      end
    end
  end
end
