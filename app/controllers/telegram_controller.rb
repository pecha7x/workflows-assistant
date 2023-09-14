class TelegramController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate!
  protect_from_forgery with: :null_session

  def message
    message_processor = TelegramBot::Message::Handler.new(message_data: JSON.parse(request.raw_post))
    message_processor.run
  ensure
    render json: {}, status: :ok
  end

  private

  def authenticate!
    secret_webhook_token = request.headers['X-Telegram-Bot-Api-Secret-Token']
    return unless secret_webhook_token.blank? || secret_webhook_token != Rails.application.credentials.telegram.webhook_token

    raise ApplicationController::UnauthorizedUsageError, 'unauthorized usage'
  end
end
