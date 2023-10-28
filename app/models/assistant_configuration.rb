# == Schema Information
#
# Table name: assistant_configurations
#
#  id                :bigint           not null, primary key
#  type              :string           not null
#  settings          :jsonb
#  user_id           :bigint           not null
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  background_job_id :string
#
class AssistantConfiguration < ApplicationRecord
  belongs_to :user
  has_many :notifiers, lambda { |ac|
    unscope(:where).where(owner_type: ac.model_name.name, owner_id: ac.id, deleted_at: nil)
  }, class_name: 'Notifier', inverse_of: :owner, dependent: :destroy # due to STI we have to use notifiers(polymorphic relation) in this odd way

  class << self
    def settings_fields
      { associated_resource_linked_to_navbar: { type: 'boolean', editable: true, visible: true } }.freeze
    end

    def visible_settings_fields
      settings_fields.select { |_k, v| v[:visible] }
    end

    def editable_settings_fields
      settings_fields.select { |_k, v| v[:editable] }
    end
  end

  store_accessor :settings, settings_fields.keys

  scope :linked_to_navbar, -> { where("settings ->> 'associated_resource_linked_to_navbar' = 'true'") }

  validates_uniqueness_of_without_deleted :type, scope: :user_id

  def name
    model_name.human
  end

  def notifiable?
    false
  end

  def associated_resource
    # implement at child STI models depends of your needs
  end
end
