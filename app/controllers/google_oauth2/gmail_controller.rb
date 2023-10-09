module GoogleOauth2
  class GmailController < ApplicationController
    before_action :initialize_client

    def auth
      authorization_uri = @client.authorization_uri(url_for(action: :callback), Google::Apis::GmailV1::AUTH_GMAIL_READONLY)

      redirect_to authorization_uri, allow_other_host: true
    end

    def callback
      @client.authorize!(url_for(action: :callback), params[:code])

      if @client.access_token
        gmail_configuration = current_user.gmail_integration || current_user.create_gmail_integration
        GmailService::AccessToken::Assign.run(gmail_configuration, @client.access_token, @client.refresh_token)
      else
        flash.now[:notice] = t('application.user_not_authorized_error')
      end

      redirect_to assistant_configurations_path
    end

    private

    def initialize_client
      @client = GoogleApiClient.new
    end
  end
end
