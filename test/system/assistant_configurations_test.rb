require "application_system_test_case"

class AssistantConfigurationsTest < ApplicationSystemTestCase
  setup do
    @assistant_configuration = assistant_configurations(:one)
  end

  test "visiting the index" do
    visit assistant_configurations_url
    assert_selector "h1", text: "Assistant configurations"
  end

  test "should create assistant configuration" do
    visit assistant_configurations_url
    click_on "New assistant configuration"

    fill_in "User", with: @assistant_configuration.user_id
    click_on "Create Assistant configuration"

    assert_text "Assistant configuration was successfully created"
    click_on "Back"
  end

  test "should update Assistant configuration" do
    visit assistant_configuration_url(@assistant_configuration)
    click_on "Edit this assistant configuration", match: :first

    fill_in "User", with: @assistant_configuration.user_id
    click_on "Update Assistant configuration"

    assert_text "Assistant configuration was successfully updated"
    click_on "Back"
  end

  test "should destroy Assistant configuration" do
    visit assistant_configuration_url(@assistant_configuration)
    click_on "Destroy this assistant configuration", match: :first

    assert_text "Assistant configuration was successfully destroyed"
  end
end
