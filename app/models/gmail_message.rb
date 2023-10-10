# == Schema Information
#
# Table name: gmail_messages
#
#  id                         :bigint           not null, primary key
#  from                       :string           not null
#  subject                    :string
#  body                       :text
#  external_id                :string           not null
#  user_id                    :bigint           not null
#  deleted_at                 :datetime
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  assistant_configuration_id :bigint           not null
#
class GmailMessage < ApplicationRecord
  include TextFieldsSanitization

  belongs_to :user
  belongs_to :gmail_integration, foreign_key: :assistant_configuration_id, inverse_of: :gmail_messages

  scope :ordered, -> { order(created_at: :desc) }
end
