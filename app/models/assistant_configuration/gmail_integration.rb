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
  # TODO: move the settings fields definition structure to base class via some decorator
  SETTINGS_FIELDS = {
    api_refresh_token: { type: 'string', editable: false, visible: false },
    gmail_user_email: { type: 'string', editable: false, visible: true },
    link_to_sidebar: { type: 'boolean', editable: true, visible: true }
  }.freeze

  class << self
    def all_settings_fields
      SETTINGS_FIELDS.keys
    end

    def visible_settings_fields
      SETTINGS_FIELDS.select { |_k, v| v[:visible] }
    end

    def editable_settings_fields
      SETTINGS_FIELDS.select { |_k, v| v[:editable] }
    end
  end

  store_accessor :settings, all_settings_fields
end
