module GoogleOauth2
  class GmailController < ApplicationController
    before_action :initialize_client

    def auth
      authorization_uri = @client.authorization_uri(url_for(action: :callback), Google::Apis::GmailV1::AUTH_GMAIL_READONLY)

      redirect_to authorization_uri, allow_other_host: true
    end

    def callback
      access_token = @client.fetch_access_token!(url_for(action: :callback), params[:code])
      session[:access_token] = access_token

      redirect_to gmail_messages_path
    end

    private

    def initialize_client
      @client = GoogleApi::Client.new
    end
  end
end
