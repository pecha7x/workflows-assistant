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
  # include Notifier::GmailIntegration

  SETTINGS_FIELDS = %i[api_refresh_token gmail_user_email].freeze

  store_accessor :settings, SETTINGS_FIELDS
end
