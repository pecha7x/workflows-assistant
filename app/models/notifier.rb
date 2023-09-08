# == Schema Information
#
# Table name: notifiers
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  kind       :integer          default("slack_webhook")
#  owner_type :string           not null
#  owner_id   :bigint           not null
#  user_id    :bigint           not null
#  settings   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#
class Notifier < ApplicationRecord
  KINDS = %i[
    slack_webhook
    email
    phone
  ].freeze

  SETTINGS_FIELDS = {
    slack_webhook: %i[url],
    email: %i[address],
    phone: %i[number]
  }.freeze

  def self.all_settings_fields
    SETTINGS_FIELDS.values.flatten.uniq
  end

  store_accessor :settings, all_settings_fields
  enum :kind, KINDS, suffix: true, default: :slack_webhook

  belongs_to :owner, polymorphic: true
  belongs_to :user

  validates :kind, :name, presence: true
  validate :kind_not_changed

  def settings_fields
    SETTINGS_FIELDS[kind.to_sym].uniq
  end

  private

  def kind_not_changed
    return unless kind_changed? && persisted?

    errors.add(:kind, 'Change of kind not allowed!')
  end
end
