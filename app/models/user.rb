# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean
#  deleted_at             :datetime
#
class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_one :assistant_configuration, dependent: :destroy
  has_many :job_sources, dependent: :destroy
  has_many :job_leads, through: :job_sources
  has_many :notifiers, dependent: :destroy
  has_many :notes, dependent: :destroy

  def name
    email.split('@').first.capitalize
  end
end
