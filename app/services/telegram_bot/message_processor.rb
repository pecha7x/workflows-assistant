require 'telegram/bot'

module TelegramBot
  class MessageProcessor
    AVAILABLE_ACTIONS = %w[start stop help].freeze

    AVAILABLE_ACTIONS.each do |action_name|
      define_method "#{action_name}_action?" do
        self.parsed_action == action_name
      end
    end

    attr_reader :bot, :current_chat_id, :parsed_action, :response_text
    
    def initialize(message_data)
      return false if message_data.blank?

      @bot = Telegram::Bot::Api.new(Rails.application.credentials.telegram.bot_token)
      p message_data
      message = Telegram::Bot::Types::Update.new(message_data).message
      @parsed_action = message.text
      @current_chat_id = message.chat.id
    end

    def run(data)
      if AVAILABLE_ACTIONS.exclude?(parsed_action)
        @response_text = "Thank you, #{@message.from.username}. But I understand only next commands - #{available_command_list} for now"
      else
        process_action unless help_action?
        build_response_text
      end
      
      send_response_to_bot
    end

    private

    def send_response_to_bot
      bot.send_message(chat_id: current_chat_id, text: "response_text")
    end

    def build_response_text
      @response_text = send("response_text_on_#{action}")
    end

    def response_text_on_start
      "I'll start"
    end

    def response_text_on_stop
      "Okay, I'll stop.. Bye!"
    end

    def response_text_on_stop
      "Will give you help"
    end

    def process_action

    end

    def available_command_list
      AVAILABLE_ACTIONS.map { |action| "/#{action}" }.join(', ')
    end
  end
end