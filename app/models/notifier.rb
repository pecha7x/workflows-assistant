# == Schema Information
#
# Table name: notifiers
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  kind            :integer          default("slack_webhook")
#  owner_type      :string           not null
#  owner_id        :bigint           not null
#  user_id         :bigint           not null
#  settings        :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#  sanitized_links :boolean          default(FALSE), not null
#
class Notifier < ApplicationRecord
  include Notifier::Telegram

  KINDS = %i[
    slack_webhook
    email
    telegram
  ].freeze

  SETTINGS_FIELDS = {
    slack_webhook: %i[webhook_url],
    email: %i[email_address],
    telegram: %i[telegram_username telegram_chat_id telegram_start_token]
  }.freeze

  def self.all_settings_fields
    SETTINGS_FIELDS.values.flatten.uniq
  end

  store_accessor :settings, all_settings_fields
  enum :kind, KINDS, suffix: true, default: :slack_webhook

  belongs_to :owner, polymorphic: true
  belongs_to :user

  after_initialize do
    self.name ||= "My new #{kind&.humanize} Notifier" if new_record?
  end

  validates :kind, :name, presence: true
  validate :kind_not_changed, if: -> { persisted? && will_save_change_to_kind? }
  validates_uniqueness_of_without_deleted :name, scope: :owner_id

  def settings_fields
    SETTINGS_FIELDS[kind.to_sym].uniq
  end

  private

  def kind_not_changed
    errors.add(:kind, 'Change of kind not allowed!')
  end
end
