require "application_system_test_case"

class JobFeedsTest < ApplicationSystemTestCase
  setup do
    login_as users(:user1)
    @job_feed = JobFeed.ordered.first
  end

  test "Showing a Job Feed" do
    visit job_feeds_path
    click_link @job_feed.name

    assert_selector "h1", text: @job_feed.name
  end

  test "Creating a new Job Feed" do
    visit job_feeds_path
    assert_selector "h1", text: "Job Feeds"

    click_on "New Job Feed"
    fill_in "Name", with: "RoR dev"

    assert_selector "h1", text: "Job Feeds"
    click_on "Create Job Feed"

    assert_selector "h1", text: "Job Feeds"
    assert_text "RoR dev"
  end

  test "Updating a Job Feed" do
    visit job_feeds_path
    assert_selector "h1", text: "Job Feeds"

    click_on "Edit", match: :first
    fill_in "Name", with: "Updated Job Feed"

    assert_selector "h1", text: "Job Feeds"
    click_on "Update Job Feed"

    assert_selector "h1", text: "Job Feeds"
    assert_text "Updated Job Feed"
  end

  test "Destroying a Job Feed" do
    visit job_feeds_path
    assert_text @job_feed.name

    click_on "Delete", match: :first
    assert_no_text @job_feed.name
  end
end
