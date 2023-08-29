require "test_helper"
require "active_support/testing/method_call_assertions"

class JobSourceTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::MethodCallAssertions
  
  test "after_create :background_processing callback" do
    job_source = JobSource.new(name: 'Test', user: users(:user1))
    assert_called(job_source, :background_processing, times: 1) do
      job_source.save
    end
  end

  test "after_save :background_processing callback" do
    job_source = JobSource.create(name: 'Test', user: users(:user1))
    job_source.search_keys = 'key2'
    job_source.expects(:background_processing)
    job_source.save
  end
end
