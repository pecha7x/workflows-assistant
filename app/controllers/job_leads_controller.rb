class JobLeadsController < ApplicationController
  before_action :set_job_source, except: [:index]
  before_action :set_job_lead, only: [:edit, :update, :destroy]
  before_action :set_status_filter

  def index
    @job_leads = current_user.job_leads.includes(:job_source).ordered
    if @status_filter.present?
      @job_leads = @job_leads.where(status: params[:status_filter])
    end
  end

  def new
    @job_lead = @job_source.job_leads.build
  end

  def create
    @job_lead = @job_source.job_leads.build(job_lead_params)

    if @job_lead.save
      respond_to do |format|
        format.html { redirect_to job_source_path(@job_source), notice: "Job Lead was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Job Lead was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @job_lead.update(job_lead_params)
      respond_to do |format|
        format.html { redirect_to job_source_path(@job_source), notice: "Job Lead was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Job Lead was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_lead.destroy

    respond_to do |format|
      format.html { redirect_to job_source_path(@job_source), notice: "Job Lead was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Job Lead was successfully destroyed." }
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
    if @status_filter.present? && JobLead.statuses.keys.exclude?(@status_filter)
      raise ActionController::ActionControllerError, 'invalid value for :status_filter parameter'
    end
  end
end
