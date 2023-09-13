module TelegramBot
  module Action
    class Stop < Base
      def run
        # TODO: to add the button for each message of notifier
        # to consider the processing "/stop all" command
        send_message_to_bot("Sorry, but for now you can stop me only via <u>Notifier(s) Settings</u> on #{APP_LINK}")
      end
    end
  end
end
