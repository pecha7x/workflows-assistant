module GoogleOauth2
  class GmailController < ApplicationController
    before_action :initialize_client

    def auth
      authorization_uri = @api_client.authorization_uri(url_for(action: :callback), Google::Apis::GmailV1::AUTH_GMAIL_READONLY)

      redirect_to authorization_uri, allow_other_host: true
    end

    def callback
      if @api_client.authorize!(url_for(action: :callback), params[:code])
        if @api_client.refresh_token
          gmail_configuration = current_user.gmail_integration || current_user.create_gmail_integration
          GmailService::AccessToken::Assign.run(gmail_configuration, @api_client.access_token, @api_client.refresh_token)
        else
          flash.now[:notice] = t('google_auth.refresh_token_blank')
        end
      else
        flash.now[:notice] = t('application.user_not_authorized_error')
      end

      redirect_to assistant_configurations_path
    end

    private

    def initialize_client
      @api_client = GoogleApiClient.new
    end
  end
end
