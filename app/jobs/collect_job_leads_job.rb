class CollectJobLeadsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false
  after_perform do |job|
    reschedule_as_next
  end
  
  attr_reader :job_feed
  delegate :kind, :refresh_rate, to: :job_feed

  def perform(job_feed_id)
    @job_feed = JobFeed.find(job_feed_id)
    "JobFeedProcessor::#{kind.capitalize}".constantize.new(job_feed_id).run
  end

  private

  def reschedule_as_next
    job_feed.background_processing(refresh_rate.seconds)
  end
end
