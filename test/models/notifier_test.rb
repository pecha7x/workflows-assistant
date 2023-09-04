require 'test_helper'

class NotifierTest < ActiveSupport::TestCase
  class Validations < NotifierTest
    test 'notifier should be valid' do
      notifier = Notifier.new(name: 'Notifier', owner: job_leads(:today_active), user: users(:user1))

      assert_predicate notifier, :valid?
    end

    class Presence < Validations
      test 'name should be present' do
        notifier = Notifier.new(name: nil, owner: job_leads(:today_active), user: users(:user1))

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
