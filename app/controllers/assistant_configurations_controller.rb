class AssistantConfigurationsController < ApplicationController
  def index
    @assistant_configurations = current_user.assistant_configurations
  end
end
