class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_many :job_feeds, dependent: :destroy
  has_many :job_leads, through: :job_feeds
  has_one :assistant_configuration

  def name
    email.split("@").first.capitalize
  end
end
