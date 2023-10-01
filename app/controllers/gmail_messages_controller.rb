class GmailMessagesController < ApplicationController
  # rescue_from GmailService::AuthorizationError, with: :client_not_authorized

  def index
    # GmailService.user_messages(access_token: session[:access_token])
    @messages = current_user.gmail_messages.page(params[:page]).per(10).ordered
  end

  def show
    @message = current_user.gmail_messages.find(params[:id])
  end

  # private

  # def client_not_authorized(_exception)
  #   redirect_to google_oauth2_gmail_auth_path
  # end
end
