module JobSourceProcessor
  class Base
    attr_reader :job_source

    def initialize(job_source_id)
      @job_source = JobSource.find(job_source_id)
    end

    def run
      raise 'Not implemented!'
    end

    private

    def log(message, severity = :info)
      BGProcessing.logger.send(severity, "#{self.class.name}. #{message}")
    end
  end
end
