module NotifierProcessor
  class Base
    POTENTIAL_TO_COLOR_MAPPING = {
      'high' => '#f71a1a',
      'medium' => '#08d51c',
      'low' => '#2e2cff'
    }.freeze

    attr_reader :settings, :from, :subject, :message, :potential

    def initialize(settings:, from:, subject:, message:, potential: 'medium')
      @settings      = settings
      @from          = from
      @subject       = subject
      @message       = message
      @potential     = potential
    end

    def run
      raise 'Not implemented!'
    end

    def potential_to_color
      POTENTIAL_TO_COLOR_MAPPING[potential]
    end
  end
end
