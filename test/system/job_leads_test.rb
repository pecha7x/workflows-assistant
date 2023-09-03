require "application_system_test_case"

class JobLeadsTest < ApplicationSystemTestCase
  setup do
    login_as users(:user1)

    @job_source = job_sources(:first)
    @job_lead = job_leads(:today_active)

    visit job_source_path(@job_source)
  end

  def current_time
    @current_time ||= Time.current
  end

  test "Creating a new job lead" do
    assert_selector "h1", text: "First job source"

    click_on "New Job Lead"
    assert_selector "h1", text: "First job source"

    fill_in "Title", with: "New Job Lead"
    fill_in "Description", with: "Description"
    fill_in "Link", with: "http://link.com"
    fill_in "Rate $/h", with: 60.0
    fill_in "Published At", with: current_time + 1.day

    click_on "Create Job Lead"
    assert_text "New Job Lead"
  end

  test "Updating Job Lead" do
    assert_selector "h1", text: "First job source"
    assert_text "Today Active"

    within id: dom_id(@job_lead) do
      find(".dropdown").click
      click_on "Edit"
    end

    assert_selector "h1", text: "First job source"

    fill_in "Title", with: "New Title"
    click_on "Update Job Lead"

    assert_text "New Title"
  end

  test "Destroying Job Lead" do
    assert_text "Today Active"

    accept_confirm do
      within id: dom_id(@job_lead) do
        find(".dropdown").click
        click_on "Delete"
      end
    end

    assert_no_text "Today Active"
  end
end
