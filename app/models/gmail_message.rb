# == Schema Information
#
# Table name: gmail_messages
#
#  id                         :bigint           not null, primary key
#  from                       :string           not null
#  short_body                 :text             not null
#  raw_body                   :text             not null
#  external_id                :string           not null
#  user_id                    :bigint           not null
#  assistant_configuration_id :bigint           not null
#  deleted_at                 :datetime
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
class GmailMessage < ApplicationRecord
  include TextFieldsSanitization

  belongs_to :user
  belongs_to :gmail_integration, foreign_key: :assistant_configuration_id, inverse_of: :gmail_messages

  scope :ordered, -> { order(created_at: :desc) }

  after_create :notify

  private

  def notify
    gmail_integration.notifiers.each do |notifier|
      NewGmailMessageNotificationJob.set(wait: 2.seconds).perform_later(id, notifier.id)
    end
  end
end
