class CollectJobLeadsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false
  after_perform do |job|
    reschedule_as_next
  end
  
  attr_reader :job_source
  delegate :kind, :refresh_rate, to: :job_source

  def perform(job_source_id)
    @job_source = JobSource.find(job_source_id)
    "JobSourceProcessor::#{kind.capitalize}".constantize.new(job_source_id).run
  end

  private

  def reschedule_as_next
    job_source.background_processing(refresh_rate.seconds)
  end
end
