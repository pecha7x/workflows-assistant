class JobSourcesController < ApplicationController
  before_action :set_job_source, only: %i[show edit update destroy]

  def index
    @job_sources = current_user.job_sources.ordered
  end

  def show
    @job_leads = @job_source.job_leads.ordered
  end

  def new
    @job_source = JobSource.new(job_source_params)
  end

  def edit; end

  def create
    @job_source = current_user.job_sources.build(job_source_params)

    if @job_source.save
      respond_to do |format|
        format.html { redirect_to edit_job_source_path(@job_source), notice: t('.notice') }
        format.turbo_stream { flash.now[:notice] = t('.notice') }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @job_source.update(job_source_params)
      respond_to do |format|
        format.html { redirect_to job_sources_path, notice: t('.notice') }
        format.turbo_stream { flash.now[:notice] = t('.notice') }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_source.destroy

    respond_to do |format|
      format.html { redirect_to job_sources_path, notice: t('.notice') }
      format.turbo_stream { flash.now[:notice] = t('.notice') }
    end
  end

  private

  def set_job_source
    @job_source = current_user.job_sources.find(params[:id])
  end

  def job_source_params
    params.fetch(:job_source, {}).permit(
      :name,
      :kind,
      :refresh_rate,
      settings: JobSource.all_settings_fields
    )
  end
end
