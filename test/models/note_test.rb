require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  class Validations < NoteTest
    test 'note should be valid' do
      note = Note.new(description: 'Description', owner: job_leads(:today_active), user: users(:user1))

      assert_predicate note, :valid?
    end

    class Presence < Validations
      test 'description should be present' do
        note = Note.new(description: nil, owner: job_leads(:today_active), user: users(:user1))

        assert_predicate note, :invalid?
        assert_has_errors_on note, :description
      end

      test 'owner should be present' do
        note = Note.new(description: 'Description', owner: nil, user: users(:user1))

        assert_predicate note, :invalid?
        assert_has_errors_on note, :owner
      end

      test 'user should be present' do
        note = Note.new(description: 'Description', owner: job_leads(:today_active), user: nil)

        assert_predicate note, :invalid?
        assert_has_errors_on note, :user
      end
    end
  end

  class NextNote < NoteTest
    test "#next_note returns the owner's next note when it exists" do
      assert_equal notes(:today_second), notes(:yesterday).next_note
    end

    test '#next_note returns nil when the owner has no next notes' do
      assert_nil notes(:today_second).next_note
    end
  end
end
