module JobFeedProcessor
  class Base
    attr_reader :job_feed, :notifiers

    def initialize(job_feed_id)
      @job_feed = JobFeed.find(job_feed_id)
    end

    def run
      raise 'Not implemented!'
    end

    private

    def log(message, severity = :info)
      BGProcessing.logger.send(severity, "#{self.class.name}.")
    end
    
    def notifiers
      @notifiers ||= job_feed.notifiers
    end

    def notice_about_lead(lead)
      notifiers.each do |notifier|
        "NotifierProcessor::#{notifier.kind.capitalize.camelize}".constantize.new(
          settings:  notifier.settings,
          from:      lead.job_feed.name,
          subject:   "#{lead.formatted_title} / $#{lead.hourly_rate} / at #{lead.published_at}",
          message:   sanitized_message(lead.description),
          potential: lead.potential
        ).run
      end
    end

    def sanitized_message(value)
      Kramdown::Document.new(value, input: 'html').to_kramdown
    end
  end
end
