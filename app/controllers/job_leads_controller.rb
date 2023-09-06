class JobLeadsController < ApplicationController
  before_action :set_job_source, except: %i[index show]
  before_action :set_job_lead, only: %i[edit update destroy]
  before_action :set_status_filter

  def index
    @job_leads = current_user.job_leads.includes(:job_source).ordered
    verify_sources_present { return }
    return if @status_filter.blank?

    @job_leads = @job_leads.where(status: params[:status_filter])
  end

  def show
    @job_lead = current_user.job_leads.find(params[:id])
    @note = Note.new(owner: @job_lead)
  end

  def new
    @job_lead = @job_source.job_leads.build
  end

  def edit; end

  def create
    @job_lead = @job_source.job_leads.build(job_lead_params)

    if @job_lead.save
      respond_to do |format|
        format.html { redirect_to job_source_path(@job_source), notice: t('.notice') }
        format.turbo_stream { flash.now[:notice] = t('.notice') }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @job_lead.update(job_lead_params)
      respond_to do |format|
        format.html { redirect_to job_source_path(@job_source), notice: t('.notice') }
        format.turbo_stream { flash.now[:notice] = t('.notice') }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_lead.destroy

    respond_to do |format|
      format.html { redirect_to job_source_path(@job_source), notice: t('.notice') }
      format.turbo_stream { flash.now[:notice] = t('.notice') }
    end
  end

  private

  def job_lead_params
    params.require(:job_lead).permit(:title, :description, :link, :potential, :status, :hourly_rate, :published_at)
  end

  def set_job_source
    @job_source = current_user.job_sources.find(params[:job_source_id])
  end

  def set_job_lead
    @job_lead = @job_source.job_leads.find(params[:id])
  end

  def set_status_filter
    @status_filter = params['status_filter'] || params.dig('job_lead', 'status_filter')
    return unless @status_filter.present? && JobLead.statuses.keys.exclude?(@status_filter)

    raise ActionController::ActionControllerError, 'invalid value for :status_filter parameter'
  end

  def verify_sources_present
    if current_user.job_sources.blank?
      redirect_to job_sources_path and yield
    end
  end
end
