require "test_helper"

class JobLeadTest < ActiveSupport::TestCase
  test "#previous_lead returns the feed's previous lead when it exists" do
    assert_equal job_leads(:last_week), job_leads(:today).previous_lead
  end

  test "#previous_lead returns nil when the feed has no previous lead" do
    assert_nil job_leads(:last_week).previous_lead
  end
end
