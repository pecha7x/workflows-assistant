require 'test_helper'

class NotifierTest < ActiveSupport::TestCase
  class Validations < NotifierTest
    test 'notifier should be valid' do
      notifier = Notifier.new(name: 'Notifier', owner: job_leads(:today_active), user: users(:user1))

      assert_predicate notifier, :valid?
    end

    class Presence < Validations
      test 'name should be present' do
        notifier = notifiers(:first)
        notifier.name = nil

        assert_predicate notifier, :invalid?
        assert_has_errors_on notifier, :name
      end

      test 'owner should be present' do
        notifier = Notifier.new(name: 'Notifier', owner: nil, user: users(:user1))

        assert_predicate notifier, :invalid?
        assert_has_errors_on notifier, :owner
      end

      test 'user should be present' do
        notifier = Notifier.new(name: 'Notifier', owner: job_leads(:today_active), user: nil)

        assert_predicate notifier, :invalid?
        assert_has_errors_on notifier, :user
      end
    end

    class Uniqueness < Validations
      test 'notifier should be valid with already been taken name but at another job_source_id scope' do
        notifier_first = notifiers(:first)
        notifier_second = notifier_first.dup
        notifier_second.owner = job_sources(:second)

        assert_predicate notifier_second, :valid?
      end

      test 'name should be unique in job_source_id scope' do
        notifier_first = notifiers(:first)
        notifier_second = notifier_first.dup

        assert_predicate notifier_second, :invalid?
        assert_has_errors_on notifier_second, :name
      end
    end

    class KindNotChanged < Validations
      test 'change of kind not allowed' do
        notifier = notifiers(:first)
        notifier.kind = 'email'

        assert_predicate notifier, :invalid?
        assert_has_errors_on notifier, :kind
      end
    end
  end

  class TelegramKind < NotifierTest
    def build_telegram_notifier(params = {})
      Notifier.new({
        name: 'Telegram Notifier',
        owner: job_sources(:first),
        user: users(:user1),
        kind: 'telegram',
        settings: {
          telegram_username: 'telegramUser'
        }
      }.merge(params))
    end

    class Validations < TelegramKind
      class TelegramFieldsPresence < Validations
        test 'telegram notifier should be valid' do
          notifier = Notifier.new(
            name: 'Notifier',
            owner: job_leads(:today_active),
            user: users(:user1),
            kind: 'telegram',
            settings: { telegram_username: 'telegramUser' }
          )

          assert_predicate notifier, :valid?
        end

        test 'telegram username should be present for a new record' do
          notifier = Notifier.new(
            name: 'Notifier',
            owner: job_leads(:today_active),
            user: users(:user1),
            kind: 'telegram'
          )

          assert_predicate notifier, :invalid?
          assert_has_errors_on notifier, :telegram_username
        end
      end

      class TelegramUsernameChanged < Validations
        test 'change of settings username not allowed for telegram kind' do
          notifier = notifiers(:telegram)
          notifier.telegram_username = 'pecha7x'

          assert_predicate notifier, :invalid?
          assert_has_errors_on notifier, :settings_field
        end
      end
    end

    class TelegramUsernameFormattedCallback < TelegramKind
      test 'should call the callback before create a telegram kind notifier' do
        notifier = build_telegram_notifier
        assert_called(notifier, :telegram_username_formatted, times: 1) do
          notifier.save
        end
      end

      test 'should remove "@" symbol from telegram_username when its present' do
        notifier = build_telegram_notifier(settings: { telegram_username: '@user123' })
        notifier.save

        assert_equal('user123', notifier.telegram_username)
      end
    end

    class GenerateStartToken < TelegramKind
      class AfterCreateCallback < GenerateStartToken
        setup do
          @notifier = build_telegram_notifier
        end

        test 'should call the callback after create a telegram kind notifier' do
          assert_called(@notifier, :generate_telegram_start_token, times: 1) do
            @notifier.save
          end
        end

        test 'should generate and set start_token after create a telegram kind notifier' do
          @notifier.save

          assert_predicate @notifier.telegram_start_token, :present?
        end

        test 'should set chat_id as null after create a telegram kind notifier' do
          @notifier.save

          assert_nil @notifier.telegram_chat_id
        end
      end

      test 'should update start_token value for an existing record' do
        notifier = notifiers(:telegram)
        old_start_token = notifier.telegram_start_token
        notifier.generate_telegram_start_token

        assert_not_equal old_start_token, notifier.telegram_start_token
        assert_not_equal nil, notifier.telegram_start_token
      end

      test 'should set chat_id as null for existing record' do
        notifier = notifiers(:telegram)
        old_chat_id = notifier.telegram_chat_id
        notifier.generate_telegram_start_token

        assert_not_equal old_chat_id, notifier.telegram_chat_id
        assert_nil notifier.telegram_chat_id
      end
    end

    class TelegramBotStart < TelegramKind
      class ConnectedBot < TelegramBotStart
        test 'should not update telegram_chat_id and telegram_start_token when the values is already present' do
          notifier = notifiers(:telegram)
          new_chat_id = 'chat43321'
          notifier.telegram_bot_start!(new_chat_id)

          assert_not_equal new_chat_id, notifier.telegram_chat_id
          assert_nil notifier.telegram_start_token
        end
      end

      class UnconnectedBot < TelegramBotStart
        include ActionCable::TestHelper

        setup do
          @notifier = notifiers(:unconnected_telegram)
          @new_chat_id = 'chat1234'
        end

        test 'should update chat_id value' do
          old_chat_id = @notifier.telegram_chat_id
          @notifier.telegram_bot_start!(@new_chat_id)

          assert_not_equal old_chat_id, @notifier.telegram_chat_id
          assert_not_equal nil, @notifier.telegram_chat_id
        end

        test 'should set telegram_start_token as null' do
          old_start_token = @notifier.telegram_start_token
          @notifier.telegram_bot_start!(@new_chat_id)

          assert_not_equal old_start_token, @notifier.telegram_start_token
          assert_nil @notifier.telegram_start_token
        end

        test 'should call broadcast_replace_to for :notifiers' do
          assert_broadcasts 'notifiers', 0

          @notifier.telegram_bot_start!(@new_chat_id)

          assert_broadcasts 'notifiers', 1
        end
      end
    end
  end
end
