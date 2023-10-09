class AssistantConfigurationsController < ApplicationController
  before_action :set_assistant_configuration, only: %i[edit update destroy]

  def index
    @assistant_configurations = AssistantConfigurations::List.run(current_user)
  end

  def new
    render "assistant_configurations/new/#{resource_name.underscore}"
  end

  def edit
    render "assistant_configurations/edit/#{resource_name.underscore}"
  end

  def update
    if @assistant_configuration.update(update_assistant_configuration_params)
      respond_to do |format|
        format.html { redirect_to assistant_configurations_path, notice: t('.notice') }
        format.turbo_stream { flash.now[:notice] = t('.notice') }
      end
    else
      render :edit, status: :unprocessable_entity
    end
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

  def update_assistant_configuration_params
    params
      .fetch(:assistant_configuration, {})
      .permit(
        :type,
        settings: @assistant_configuration.class.editable_settings_fields.keys
      )
  end

  def resource_name
    @assistant_configuration.class.name
  end
end
