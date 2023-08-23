class AssistantConfigurationsController < ApplicationController
  before_action :set_assistant_configuration, only: %i[ show edit update destroy ]

  def index
    @assistant_configurations = AssistantConfiguration.all
  end

  private
    def set_assistant_configuration
      @assistant_configuration = AssistantConfiguration.find(params[:id])
    end
end
