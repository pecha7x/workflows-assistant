class JobFeed < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  broadcasts_to ->(job_feed) { [job_feed.user, "job_feeds"] }, inserts_by: :prepend

  belongs_to :user
  has_many :job_leads, dependent: :destroy
end
