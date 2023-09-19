class GoogleOauth2::GmailController < ApplicationController
  def auth
    client = Signet::OAuth2::Client.new({
      client_id: Rails.application.credentials.google_api.client_id,
      client_secret: Rails.application.credentials.google_api.client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::GmailV1::AUTH_GMAIL_READONLY,
      redirect_uri: url_for(action: :callback)
    })

    redirect_to client.authorization_uri.to_s, allow_other_host: true
  end

  def callback
    client = Signet::OAuth2::Client.new({
      client_id: Rails.application.credentials.google_api.client_id,
      client_secret: Rails.application.credentials.google_api.client_secret,
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: url_for(action: :callback),
      code: params[:code]
    })
  
    response = client.fetch_access_token!
  
    session[:access_token] = response['access_token']
  
    redirect_to gmail_messages_path
  end
end
