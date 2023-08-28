class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_many :job_feeds, dependent: :destroy
  has_many :job_leads, through: :job_feeds
  has_many :notifiers, dependent: :destroy
  has_one :assistant_configuration, dependent: :destroy

  def name
    email.split("@").first.capitalize
  end
end
