module NotifierProcessor
  class SlackWebhook < Base
    POTENTIAL_TO_COLOR_MAPPING = {
      'high' => '#f71a1a',
      'medium' => '#08d51c',
      'low' => '#2e2cff'
    }.freeze

    alias note_text message

    def run
      SlackPublisher.new(
        message: subject,
        note_text:,
        note_color:,
        channel_url:,
        username: from
      ).publish
    end

    private

    def note_color
      POTENTIAL_TO_COLOR_MAPPING[potential]
    end

    def channel_url
      settings['url']
    end
  end
end
