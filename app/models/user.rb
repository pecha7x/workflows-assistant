class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_many :job_feeds, dependent: :destroy

  def name
    email.split("@").first.capitalize
  end
end
