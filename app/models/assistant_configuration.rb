# == Schema Information
#
# Table name: assistant_configurations
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AssistantConfiguration < ApplicationRecord
  belongs_to :user
end
