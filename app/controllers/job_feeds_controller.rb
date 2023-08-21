class JobFeedsController < ApplicationController
  before_action :set_job_feed, only: [:show, :edit, :update, :destroy]

  def index
    @job_feeds = current_user.job_feeds.ordered
  end

  def show
    @job_leads = @job_feed.job_leads.ordered
  end

  def new
    @job_feed = JobFeed.new
  end

  def create
    @job_feed = current_user.job_feeds.build(job_feed_params)

    if @job_feed.save
      respond_to do |format|
        format.html { redirect_to job_feeds_path, notice: "Job Feed was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Job Feed was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @job_feed.update(job_feed_params)
      respond_to do |format|
        format.html { redirect_to job_feeds_path, notice: "Job Feed was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Job Feed was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_feed.destroy
    
    respond_to do |format|
      format.html { redirect_to job_feeds_path, notice: "Job Feed was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Job Feed was successfully destroyed." }
    end
  end

  private

  def set_job_feed
    @job_feed = current_user.job_feeds.find(params[:id])
  end

  def job_feed_params
    params.require(:job_feed).permit(:name)
  end
end
