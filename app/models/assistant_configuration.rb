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
  has_many :notifiers, lambda { |ac|
    unscope(:where).where(owner_type: ac.model_name.name, owner_id: ac.id, deleted_at: nil)
  }, class_name: 'Notifier', inverse_of: :owner, dependent: :destroy # due to STI we have to use notifiers(polymorphic relation) in this odd way

  def name
    model_name.human
  end
end
