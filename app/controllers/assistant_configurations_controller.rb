class AssistantConfigurationsController < ApplicationController
  def index
    @assistant_configurations = AssistantConfigurations.list(current_user)
  end

  def new
    @assistant_configuration = current_user.assistant_configurations.build(assistant_configuration_params)
    
    render "assistant_configurations/new/#{@assistant_configuration.class.name.underscore}"
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
