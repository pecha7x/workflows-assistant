require "application_system_test_case"

class JobLeadsTest < ApplicationSystemTestCase
  setup do
    login_as users(:user1)

    @job_source = job_sources(:first)
    @job_lead = job_leads(:today)

    visit job_source_path(@job_source)
  end

  def current_time
    @current_time ||= Time.current
  end

  test "Creating a new job lead" do
    assert_selector "h1", text: "First job source"

    click_on "New Job Lead"
    assert_selector "h1", text: "First job source"
    fill_in "Published At", with: current_time + 1.day

    click_on "Create Job Lead"
    assert_text I18n.l(current_time + 1.day, format: :long)
  end

  test "Updating a new job" do
    assert_selector "h1", text: "First job source"

    within id: dom_id(@job_lead) do
      click_on "Edit"
    end

    assert_selector "h1", text: "First job source"

    fill_in "Published At", with: current_time + 1.day
    click_on "Update Job Lead"

    assert_text I18n.l(current_time + 1.day, format: :long)
  end

  test "Destroying a new job" do
    assert_text I18n.l(@job_lead.published_at, format: :long)

    accept_confirm do
      within id: dom_id(@job_lead) do
        click_on "Delete"
      end
    end

    assert_no_text I18n.l(@job_lead.published_at, format: :long)
  end
end
