class TelegramController < ApplicationController
  skip_before_action :authenticate_user!
  # before_action :authenticate!
  protect_from_forgery with: :null_session

  def message
    Rails.logger.info("TELEGRAM webhook raw body: #{request.raw_post}")
    Rails.logger.info("TELEGRAM webhook json parsed: #{JSON.parse(request.raw_post)}")
    # message_processor = TelegramBot::MessageProcessor.new(JSON.parse(request.raw_post))
    # bot.run if message_processor

    render json: {}, status: :ok
  end

  private

  def authenticate!
    secret_webhook_token = request.headers['X-Telegram-Bot-Api-Secret-Token']
    if secret_webhook_token.blank? || secret_webhook_token != Rails.application.credentials.telegram.webhook_token
      raise ApplicationController::UnauthorizedUsageError, 'unauthorized usage' 
    end
  end
end
