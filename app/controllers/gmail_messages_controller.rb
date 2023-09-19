class GmailMessagesController < ApplicationController
  rescue_from Google::Apis::AuthorizationError, with: :client_not_authorized
  rescue_from Signet::AuthorizationError, with: :client_not_authorized

  def index
    client = Signet::OAuth2::Client.new(access_token: session[:access_token])
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = client
    @messages_list = service.list_user_messages('me')
  end

  private

  def client_not_authorized(exception)
    flash[:notice] = t('application.user_not_authorized_error')
    redirect_to google_oauth2_gmail_auth_path
  end
end
