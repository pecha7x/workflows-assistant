class AssistantConfigurationsController < ApplicationController
  before_action :set_assistant_configuration, only: %i[edit update destroy]

  def index
    @assistant_configurations = AssistantConfigurations::List.run(current_user)
  end

  def new
    @assistant_configuration = current_user.assistant_configurations.build(type: params[:assistant_configuration][:type])
    render "assistant_configurations/new/#{@assistant_configuration.class.name.underscore}"
  end

  def edit
    render "assistant_configurations/edit/#{@assistant_configuration.class.name.underscore}"
  end

  def update
    permitted_params_of_settings.each { |k, v| @assistant_configuration.send("#{k}=", v) }
    if @assistant_configuration.save
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

  def permitted_params_of_settings
    params
      .fetch(:assistant_configuration, {})
      .fetch(:settings, {})
      .permit(
        @assistant_configuration.class.editable_settings_fields.keys
      )
  end
end
