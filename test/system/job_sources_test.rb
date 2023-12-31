require 'application_system_test_case'

class JobSourcesTest < ApplicationSystemTestCase
  setup do
    login_as users(:user1)
    @job_source = JobSource.ordered.first
  end

  test 'Showing a Job Source' do
    visit job_sources_path
    click_link @job_source.name

    assert_selector 'h2', text: @job_source.name
  end

  test 'Creating a new Job Source' do
    visit job_sources_path

    assert_selector 'h2', text: 'Job Sources'

    click_on 'New Job Source'
    fill_in 'Name', with: 'RoR dev'
    click_on 'Save'

    assert_selector 'h2', text: 'Job Sources'
    assert_text 'RoR dev'
  end

  test 'Updating a Job Source' do
    visit job_sources_path

    assert_selector 'h2', text: 'Job Sources'

    click_on 'Edit', match: :first
    fill_in 'Name', with: 'Updated Job Source'
    click_on 'Save'

    assert_selector 'h2', text: 'Job Sources'
    assert_text 'Updated Job Source'
  end

  test 'Destroying a Job Source' do
    visit job_sources_path

    assert_text @job_source.name

    accept_confirm do
      click_on 'Delete', match: :first
    end

    assert_selector 'h2', text: 'Job Sources'
    assert_no_text @job_source.name
  end
end
