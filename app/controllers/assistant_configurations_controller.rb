class AssistantConfigurationsController < ApplicationController
  before_action :set_assistant_configuration, only: %i[destroy]

  def index
    @assistant_configurations = AssistantConfigurations::List.run(current_user)
  end

  def new
    @assistant_configuration = current_user.assistant_configurations.build(assistant_configuration_params)

    render "assistant_configurations/new/#{@assistant_configuration.class.name.underscore}"
  end

  def destroy
    @assistant_configuration.destroy

    respond_to do |format|
      format.html { redirect_to assistant_configurations_path, notice: t('.notice') }
      format.turbo_stream { flash.now[:notice] = t('.notice') }
    end
  end

  private

  def set_assistant_configuration
    @assistant_configuration = current_user.assistant_configurations.find(params[:id])
  end

  def assistant_configuration_params
    params
      .fetch(:assistant_configuration, {})
      .permit(
        :type,
        settings: params[:assistant_configuration][:type].constantize::SETTINGS_FIELDS
      )
  end
end
