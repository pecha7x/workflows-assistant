module GmailService
  class ApiClient
    # https://github.com/googleapis/google-api-ruby-client/blob/main/generated/google-apis-gmail_v1/lib/google/apis/gmail_v1/service.rb
    attr_reader :service

    def initialize(access_token)
      client = GoogleApiClient.new
      client.access_token = access_token
      @service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client.signet_client
    end

    def user_profile
      service.get_user_profile('me')
    end

    def user_messages
      service.list_user_messages('me')
    end

    def user_message(id)
      service.get_user_message('me', id)
    end
  end
end
