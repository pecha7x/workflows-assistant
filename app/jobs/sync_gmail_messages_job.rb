class SyncGmailMessagesJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false
  after_perform do |_job|
    reschedule_as_next
  rescue StandardError => e
    log(e.message, :error)
  end

  attr_reader :gmail_integration

  def perform(gmail_integration_id)
    @gmail_integration = GmailIntegration.find(gmail_integration_id)
    AssistantConfigurations::Sync::GmailIntegration.new(gmail_integration_id).run
  rescue StandardError => e
    log(e.message, :error)
  end

  private

  def reschedule_as_next
    gmail_integration.background_processing
  end
end
