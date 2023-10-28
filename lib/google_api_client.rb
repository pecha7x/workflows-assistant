class GoogleApiClient
  # https://googleapis.dev/ruby/signet/latest/Signet/OAuth2/Client.html
  BASE_AUTHORIZATION_URI = 'https://accounts.google.com/o/oauth2/auth'.freeze
  TOKEN_CREDENTIAL_URI = 'https://accounts.google.com/o/oauth2/token'.freeze

  attr_reader :signet_client

  delegate :access_token, :refresh_token, to: :signet_client

  def initialize
    @signet_client = Signet::OAuth2::Client.new(
      client_id: Rails.application.credentials.google_api.client_id,
      client_secret: Rails.application.credentials.google_api.client_secret
    )
  end

  def authorization_uri(redirect_uri, scope)
    signet_client.update!(
      authorization_uri: BASE_AUTHORIZATION_URI,
      redirect_uri:,
      scope:
    )
    signet_client.authorization_uri.to_s
  end

  def authorize!(redirect_uri, code)
    signet_client.update!(
      token_credential_uri: TOKEN_CREDENTIAL_URI,
      redirect_uri:,
      code:
    )

    response = signet_client.fetch_access_token!

    response['access_token']&.present?
  rescue Signet::AuthorizationError => e
    Rails.logger.error("Fetch access token Error - #{e.message}")
    nil
  end

  def fetch_access_token!(refresh_token)
    signet_client.update!(
      token_credential_uri: TOKEN_CREDENTIAL_URI,
      refresh_token:
    )
    response = signet_client.fetch_access_token!

    response['access_token']
  rescue Signet::AuthorizationError => e
    Rails.logger.error("Fetch access token Error - #{e.message}")
    nil
  end

  def access_token=(value)
    signet_client.update!(access_token: value)
  end
end
