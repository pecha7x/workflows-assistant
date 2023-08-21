class JobLeadsController < ApplicationController
  before_action :set_job_feed
  before_action :set_job_lead, only: [:edit, :update, :destroy]

  def new
    @job_lead = @job_feed.job_leads.build
  end

  def create
    @job_lead = @job_feed.job_leads.build(job_lead_params)

    if @job_lead.save
      respond_to do |format|
        format.html { redirect_to job_feed_path(@job_feed), notice: "Job Lead was successfully created." }
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
        format.html { redirect_to job_feed_path(@job_feed), notice: "Job Lead was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Job Lead was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_lead.destroy

    respond_to do |format|
      format.html { redirect_to job_feed_path(@job_feed), notice: "Job Lead was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Job Lead was successfully destroyed." }
    end
  end

  private

  def job_lead_params
    params.require(:job_lead).permit(:published_at)
  end

  def set_job_feed
    @job_feed = current_user.job_feeds.find(params[:job_feed_id])
  end

  def set_job_lead
    @job_lead = @job_feed.job_leads.find(params[:id])
  end
end
