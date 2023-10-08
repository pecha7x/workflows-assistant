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
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#
class User < ApplicationRecord
  devise :database_authenticatable, :validatable, :confirmable,
         :registerable, :recoverable, :rememberable

  has_many :assistant_configurations, dependent: :destroy
  has_one :gmail_integration, dependent: :destroy

  has_many :gmail_messages, dependent: :destroy
  has_many :job_sources, dependent: :destroy
  has_many :job_leads, through: :job_sources
  has_many :notifiers, dependent: :destroy
  has_many :notes, dependent: :destroy

  validates_password_strength :password
  validates_uniqueness_of_without_deleted :email

  def name
    email.split('@').first.capitalize
  end

  def remember_me
    super.nil? ? '1' : super
  end
end
