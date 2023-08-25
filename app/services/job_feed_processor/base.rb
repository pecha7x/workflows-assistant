module JobFeedProcessor
  class Base
    attr_reader :job_feed

    def initialize(job_feed_id)
      @job_feed = JobFeed.find(job_feed_id)
    end

    def run
      raise 'Not implemented!'
    end

    def log(message, severity = :info)
      BGProcessing.logger.send(severity, "#{self.class.name}.")
    end
  end
end
