require 'test_helper'

class StartTokenTest < ActiveSupport::TestCase
  class GenerateToken < StartTokenTest
    def generate(object)
      TelegramBot::StartToken.generate_token(object)
    end

    test 'should be success return a new token key for a Notifier' do
      notifier = notifiers(:telegram)
      new_token = generate(notifier)

      assert_predicate(new_token, :present?)
    end

    test 'should raise an exception in trying to generate token for an unsupported model' do
      user = users(:user1)

      error = assert_raises RuntimeError do
        generate(user)
      end

      assert_equal "'User' is not allowed for build parameters", error.message
    end

    test 'should be an unique value any time' do
      notifier = notifiers(:telegram)
      new_token1 = generate(notifier)
      new_token2 = generate(notifier)

      assert_predicate(new_token1, :present?)
      assert_predicate(new_token2, :present?)
      assert_not_equal new_token1, new_token2
    end
  end

  class PullTokenValue < StartTokenTest
    setup do
      @notifier = notifiers(:telegram)
      @token = TelegramBot::StartToken.generate_token(@notifier)
    end

    test 'should be success pulled the token value for a Notifier be the key' do
      token_value = TelegramBot::StartToken.pull_token_value(@token)

      assert_predicate(token_value, :present?)
      assert_equal 'Notifier', token_value['object']
      assert_equal @notifier.id, token_value.dig('attributes', 'id')
    end
  end
end
