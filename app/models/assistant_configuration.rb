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
class AssistantConfiguration < ApplicationRecord
  belongs_to :user

  def name
    model_name.human
  end
end
