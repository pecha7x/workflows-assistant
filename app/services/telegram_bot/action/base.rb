module TelegramBot
  module Action
    class Base
      attr_reader :message

      def initialize(message:)
        @message = message
      end

      def run
      end
    end
  end  
end
