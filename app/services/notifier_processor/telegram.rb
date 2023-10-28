module NotifierProcessor
  class Telegram < Base
    def run
      TelegramBot::Message::Sender.new(message_text:, chat_id: settings['telegram_chat_id'], parse_mode: 'HTML').run
    end

    private

    def message_text
      text = "New Record from <u>#{from}</u>:&#10;&#10;"
      text += "#{subject}&#10;&#10;"
      text += message
      text
    end
  end
end
