# == Schema Information
#
# Table name: assistant_configurations
#
#  id                :bigint           not null, primary key
#  type              :string           not null
#  settings          :jsonb
#  user_id           :bigint           not null
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  background_job_id :string
#
class GmailIntegration < AssistantConfiguration
  REFRESH_RATE_IN_SECONDS = 360

  has_many :gmail_messages, foreign_key: :assistant_configuration_id, inverse_of: :gmail_integration, dependent: :destroy

  def self.settings_fields
    {
      api_refresh_token: { type: 'string', editable: false, visible: false },
      gmail_user_email: { type: 'string', editable: false, visible: true }
    }.merge(super).freeze
  end

  store_accessor :settings, settings_fields.keys

  after_update :background_processing, if: -> { saved_change_to_settings? && api_refresh_token.present? }
  before_destroy :cancel_background_job

  def notifiable?
    true
  end

  def associated_resource
    GmailMessage
  end

  def background_processing
    cancel_background_job

    bg_job = SyncGmailMessagesJob.set(wait: REFRESH_RATE_IN_SECONDS.seconds).perform_later(id)
    bg_job && update(background_job_id: bg_job.provider_job_id)
  end

  private

  def cancel_background_job
    # TODO: add more logic when background_job is running
    return if background_job_id.blank?

    Sidekiq::Status.unschedule(background_job_id)
  end
end
