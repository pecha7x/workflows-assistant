# == Schema Information
#
# Table name: assistant_configurations
#
#  id         :bigint           not null, primary key
#  type       :string           not null
#  settings   :jsonb
#  user_id    :bigint           not null
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class GmailIntegration < AssistantConfiguration
  has_many :gmail_messages, foreign_key: :assistant_configuration_id, inverse_of: :gmail_integration, dependent: :destroy

  def self.settings_fields
    {
      api_refresh_token: { type: 'string', editable: false, visible: false },
      gmail_user_email: { type: 'string', editable: false, visible: true }
    }.merge(super).freeze
  end

  store_accessor :settings, settings_fields.keys

  def notifiable?
    true
  end

  def associated_resource
    GmailMessage
  end
end
