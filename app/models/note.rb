# == Schema Information
#
# Table name: notes
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  owner_type  :string           not null
#  owner_id    :bigint           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Note < ApplicationRecord
  include TextFieldsSanitization

  belongs_to :owner, polymorphic: true
  belongs_to :user

  scope :ordered, -> { order(created_at: :desc) }

  validates :description, :owner, presence: true

  def next_note
    owner.notes.where("created_at > ?", created_at).ordered.last  
  end
end
