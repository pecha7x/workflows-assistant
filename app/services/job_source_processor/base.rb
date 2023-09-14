module JobSourceProcessor
  class Base
    delegate :time_ago_in_words, :link_to, to: 'ActionController::Base.helpers'
    delegate :job_source_job_lead_url, to: 'Rails.application.routes.url_helpers'

    attr_reader :job_source, :notifiers

    def initialize(job_source_id)
      @job_source = JobSource.find(job_source_id)
      @notifiers = job_source.notifiers
    end

    def run
      raise 'Not implemented!'
    end

    private

    def log(_message, severity = :info)
      BGProcessing.logger.send(severity, "#{self.class.name}.")
    end

    def notice_about_lead(lead)
      notifiers.each do |notifier|
        "NotifierProcessor::#{notifier.kind.capitalize.camelize}".constantize.new(
          settings: notifier.settings,
          from: lead.job_source.name,
          subject: subject_by(lead),
          message: lead.sanitized_description(sanitize_links: notifier.sanitized_links),
          potential: lead.potential
        ).run
      end
    end

    def subject_by(lead)
      title_link = link_to(lead.formatted_title, job_source_job_lead_url(lead.job_source, lead))
      "#{title_link} / $#{lead.hourly_rate} / #{time_ago_in_words(lead.published_at)} ago"
    end
  end
end
