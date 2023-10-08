module GmailService
  class AuthorizationError < StandardError; end

  # https://github.com/googleapis/google-api-ruby-client/blob/main/generated/google-apis-gmail_v1/lib/google/apis/gmail_v1/service.rb
  def self.user_messages(access_token:)
    client = GoogleApiClient.new
    client.access_token = access_token

    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = client.signet_client

    service.list_user_messages('me')
  rescue Google::Apis::AuthorizationError => e
    Rails.logger.error("Get user messages Error - #{e.message}")
    raise GmailService::AuthorizationError
  end
end
