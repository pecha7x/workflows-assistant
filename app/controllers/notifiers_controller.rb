class NotifiersController < ApplicationController
  before_action :set_owner_from_params, only: %i[new create update]
  before_action :set_notifier, only: %i[edit update destroy refresh_telegram_token]

  def new
    @notifier = current_user.notifiers.build(notifier_params)
  end

  def edit
    @owner = @notifier.owner
  end

  def create
    @notifier = current_user.notifiers.build(notifier_params)
    if @notifier.save
      respond_to do |format|
        path = @notifier.telegram_kind? ? edit_notifier_path(@notifier) : edit_polymorphic_path(@owner)
        format.html { redirect_to path, notice: t('.notice') }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @notifier.update(notifier_params)
      respond_to do |format|
        format.html { redirect_to edit_polymorphic_path(@owner), notice: t('.notice') }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @notifier.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t('.notice') }
    end
  end

  def refresh_telegram_token
    @notifier.generate_telegram_start_token

    # render status: :ok
    respond_to do |format|
      format.html { redirect_to edit_notifier_path(@notifier), notice: t('.notice') }
      format.turbo_stream { flash.now[:notice] = t('.notice') }
    end
  end

  private

  def set_notifier
    @notifier = current_user.notifiers.find(params[:id])
  end

  def set_owner_from_params
    @owner = notifier_params[:owner_type].constantize.find_by(id: notifier_params[:owner_id], user_id: current_user.id)
  end

  def notifier_params
    params.fetch(:notifier, {}).permit(
      :owner_id,
      :owner_type,
      :name,
      :kind,
      :sanitized_links,
      settings: Notifier.all_settings_fields
    )
  end
end
