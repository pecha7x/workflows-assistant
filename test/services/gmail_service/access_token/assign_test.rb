require 'test_helper'

class AssignGmailAccessTokenTest < ActiveSupport::TestCase
  test 'should be success assign the token key to a gmail_configuration' do
    token = SecureRandom.uuid
    refresh_token = SecureRandom.uuid
    gmail_configuration = gmail_integrations(:first)
    service = GmailService::AccessToken::Assign.new(gmail_configuration:, token:, refresh_token:)
    service.stubs(:gmail_user_email).returns('email@example.com')
    service.run

    assert_equal(refresh_token, gmail_configuration.api_refresh_token)
    assert_equal('email@example.com', gmail_configuration.gmail_user_email)
  end
end
