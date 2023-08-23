require "test_helper"

class AssistantConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assistant_configuration = assistant_configurations(:one)
  end

  test "should get index" do
    get assistant_configurations_url
    assert_response :success
  end
end
