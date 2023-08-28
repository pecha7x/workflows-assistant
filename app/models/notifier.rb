class Notifier < ApplicationRecord
  KINDS = %i(
    slack_webhook
    email
    phone
  ).freeze

  SETTINGS_FIELDS = {
    slack_webhook: %i( url ),
    email:         %i( address subject ),
    phone:         %i( number )
  }.freeze

  def self.all_settings_fields
    SETTINGS_FIELDS.values.flatten.uniq
  end

  store_accessor :settings, all_settings_fields
  enum :kind, KINDS, suffix: true, default: :slack_webhook

  belongs_to :owner, polymorphic: true
  belongs_to :user

  validates :kind, :name, :owner_id, :owner_type, :user_id, presence: true
  validate :kind_not_changed

  def settings_fields
    SETTINGS_FIELDS[kind.to_sym].uniq
  end

  private

  def kind_not_changed
    if kind_changed? && self.persisted?
      errors.add(:kind, "Change of kind not allowed!")
    end
  end
end
