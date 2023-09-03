class NotesController < ApplicationController
  before_action :set_owner_from_params, only: %i[ new create ]
  before_action :set_note, only: %i[ destroy ]

  def new
    @note = current_user.notes.build(note_params)
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      respond_to do |format|
        format.html { redirect_to edit_polymorphic_path(@owner), notice: "Note was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Note was successfully created." }
      end  
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Note was successfully destroyed." }
    end
  end

  private

  def set_note
    @note = current_user.notes.find(params[:id])
  end

  def set_owner_from_params
    owner_class = note_params[:owner_type].constantize
    if owner_class.respond_to?(:user_id)
      @owner = owner_class.find_by(id: note_params[:owner_id], user_id: current_user.id)
    else
      @owner = owner_class.find(note_params[:owner_id])
      raise ActionController::ActionControllerError, 'tried to assign owner from not unauthorized user' if @owner.user != current_user
    end
  end

  def note_params
    params.fetch(:note, {}).permit(
      :description,
      :owner_id,
      :owner_type
    )
  end
end
