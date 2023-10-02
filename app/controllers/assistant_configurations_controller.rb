class AssistantConfigurationsController < ApplicationController
  def index
    @assistant_configurations = AssistantConfigurations.list(current_user)
  end

  def new
    @assistant_configuration = AssistantConfiguration.new(assistant_configuration_params)
  end

  private

  def assistant_configuration_params
    params
      .fetch(:assistant_configuration, {})
      .permit(
        :type,
        settings: params[:assistant_configuration][:type].constantize::SETTINGS_FIELDS
      )
  end
end
