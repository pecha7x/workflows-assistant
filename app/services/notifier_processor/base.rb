module NotifierProcessor
  class Base
    attr_reader :settings, :from, :subject, :message, :potential

    def initialize(settings:, from:, subject:, message:, potential:)
      @settings  = settings
      @from      = from
      @subject   = subject
      @message   = message
      @potential = potential
    end

    def run
      raise 'Not implemented!'
    end
  end
end
