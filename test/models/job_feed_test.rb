require "test_helper"
require "active_support/testing/method_call_assertions"

class JobFeedTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::MethodCallAssertions
  
  test "after_create :background_processing callback" do
    job_feed = JobFeed.new(name: 'Test', user: users(:user1))
    assert_called(job_feed, :background_processing, times: 1) do
      job_feed.save
    end
  end

  test "after_save :background_processing callback" do
    job_feed = JobFeed.create(name: 'Test', user: users(:user1))
    job_feed.search_keys = 'key2'
    job_feed.expects(:background_processing)
    job_feed.save
  end
end
