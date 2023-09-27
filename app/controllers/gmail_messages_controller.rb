class GmailMessagesController < ApplicationController
  rescue_from GmailService::AuthorizationError, with: :client_not_authorized

  def index
    @messages_list = GmailService.user_messages(access_token: session[:access_token])
  end

  private

  def client_not_authorized(_exception)
    redirect_to google_oauth2_gmail_auth_path
  end
end
