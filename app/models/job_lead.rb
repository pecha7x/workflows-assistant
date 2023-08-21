class JobLead < ApplicationRecord
  belongs_to :job_feed

  validates :published_at, presence: true

  scope :ordered, -> { order(published_at: :asc) }

  def previous_lead
    job_feed.job_leads.ordered.where("published_at < ?", published_at).last
  end
end
