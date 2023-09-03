module JobSourceProcessor
  class Base
    include ActionView::Helpers::DateHelper

    attr_reader :job_source, :notifiers

    def initialize(job_source_id)
      @job_source = JobSource.find(job_source_id)
    end

    def run
      raise 'Not implemented!'
    end

    private

    def log(message, severity = :info)
      BGProcessing.logger.send(severity, "#{self.class.name}.")
    end
    
    def notifiers
      @notifiers ||= job_source.notifiers
    end

    def notice_about_lead(lead)
      notifiers.each do |notifier|
        "NotifierProcessor::#{notifier.kind.capitalize.camelize}".constantize.new(
          settings:  notifier.settings,
          from:      lead.job_source.name,
          subject:   "#{lead.formatted_title} / $#{lead.hourly_rate} / #{time_ago_in_words(lead.published_at)} ago",
          message:   lead.sanitized_description,
          potential: lead.potential
        ).run
      end
    end
  end
end
