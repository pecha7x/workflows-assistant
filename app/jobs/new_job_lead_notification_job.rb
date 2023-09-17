class NewJobLeadNotificationJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  delegate :time_ago_in_words, :link_to, to: 'ActionController::Base.helpers'
  delegate :job_lead_url, to: 'Rails.application.routes.url_helpers'

  attr_reader :job_lead

  def perform(job_lead_id, notifier_id)
    @job_lead = JobLead.find(job_lead_id)
    notifier = job_lead.notifiers.find(notifier_id)

    "NotifierProcessor::#{notifier.kind.capitalize.camelize}".constantize.new(
      settings: notifier.settings,
      from: job_lead.job_source.name,
      subject: job_lead_subject,
      message: job_lead.sanitized_description(sanitize_links: notifier.sanitized_links),
      potential: job_lead.potential
    ).run
  end

  private

  def job_lead_subject
    title_link = link_to(job_lead.formatted_title, job_lead_url(job_lead))
    "#{title_link} / $#{job_lead.hourly_rate} / #{time_ago_in_words(job_lead.published_at)} ago"
  end
end
