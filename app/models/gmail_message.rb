# == Schema Information
#
# Table name: gmail_messages
#
#  id          :bigint           not null, primary key
#  from        :string           not null
#  subject     :string
#  body        :text
#  external_id :string           not null
#  user_id     :bigint           not null
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class GmailMessage < ApplicationRecord
  include TextFieldsSanitization

  belongs_to :user

  scope :ordered, -> { order(created_at: :desc) }
end
