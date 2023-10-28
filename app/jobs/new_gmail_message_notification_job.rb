class NewGmailMessageNotificationJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  delegate :time_ago_in_words, :link_to, to: 'ActionController::Base.helpers'

  attr_reader :gmail_message

  def perform(gmail_message_id, notifier_id)
    @gmail_message = GmailMessage.find(gmail_message_id)
    gmail_integration = gmail_message.gmail_integration
    notifier = gmail_integration.notifiers.find(notifier_id)

    "NotifierProcessor::#{notifier.kind.capitalize.camelize}".constantize.new(
      settings: notifier.settings,
      from: gmail_integration.name,
      subject: gmail_message_subject,
      message: gmail_message.sanitized_short_body(sanitize_links: notifier.sanitized_links)
    ).run
  end

  private

  def gmail_message_subject
    "Message from #{gmail_message.from.gsub(/<|>/, '')} / #{time_ago_in_words(gmail_message.created_at)} ago"
  end
end
