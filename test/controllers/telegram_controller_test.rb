require 'test_helper'

class TelegramControllerTest < ActionDispatch::IntegrationTest
  class Message < TelegramControllerTest
    class Authentication < Message
      test 'post message without token should be forbidden' do
        post telegram_message_path

        assert_response 403
        assert_equal('Access denied.', response.parsed_body['errors']['message'])
      end

      test 'post message with invalid token should be forbidden' do
        post telegram_message_path, headers: { 'X-Telegram-Bot-Api-Secret-Token': 'invalid_token_value' }

        assert_response 403
        assert_equal('Access denied.', response.parsed_body['errors']['message'])
      end

      test 'post message with valid token should return success response' do
        post telegram_message_path, params: '{}', session: { headers: { 'X-Telegram-Bot-Api-Secret-Token': Rails.application.credentials.telegram.webhook_token } }

        assert_response 200
      end
    end
  end
end
