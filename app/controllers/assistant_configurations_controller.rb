class AssistantConfigurationsController < ApplicationController
  def settings
    @assistant_configuration = current_user.assistant_configuration
  end
end
