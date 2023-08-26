class JobLead < ApplicationRecord
  enum :status, [ :entry, :in_progress, :not_interested ], suffix: true, default: :entry
  enum :potential, [ :low, :medium, :high ], suffix: true, default: :medium

  belongs_to :job_feed

  validates :published_at, :description, :title, :link, :status, :potential, presence: true
  validates :hourly_rate, presence: true, numericality: { greater_than: 0 }
  validates :external_id, presence: true, uniqueness: { scope: :job_feed_id }

  delegate :user, to: :job_feed

  scope :ordered, -> { order(published_at: :desc) }

  broadcasts_to ->(job_lead) { [job_lead.user, "job_leads"] }, inserts_by: :prepend

  def previous_lead
    job_feed.job_leads.ordered.where("published_at < ?", published_at).last
  end
end
