module NotifierProcessor
  class SlackWebhook < Base
    POTENTIAL_TO_COLOR_MAPPING = {
      'high' => '#f71a1a',
      'medium' => '#08d51c',
      'low' => '#2e2cff'
    }.freeze

    alias note_text message
    alias note_color potential_to_color

    def run
      SlackSender.new(
        message: subject,
        note_text:,
        note_color:,
        channel_url:,
        username: from
      ).run
    end

    private

    def channel_url
      settings['webhook_url']
    end
  end
end
