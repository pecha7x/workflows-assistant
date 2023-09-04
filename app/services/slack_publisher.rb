class SlackPublisher
  attr_reader :message, :note_text, :note_color, :channel_url, :notifier

  def initialize(message:, note_color:, channel_url:, note_text: '', username: 'SlackPublish')
    @message      = message
    @note_text    = note_text
    @note_color   = note_color
    @channel_url  = channel_url

    @notifier = Slack::Notifier.new(@channel_url, username:)
  end

  def publish
    notifier.ping message, attachments: [note]
  end

  private

  def note
    {
      fallback: note_text,
      text: note_text,
      color: note_color,
      mrkdwn_in: %w[text pretext] # cspell:disable-line
    }
  end
end
