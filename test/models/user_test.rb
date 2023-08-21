require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name" do
    assert_equal "User1", users(:user1).name
  end
end
