class JobFeed < ApplicationRecord
  REFRESH_RATES = [ 30, 60, 120, 360 ].freeze

  KINDS = %i(
    upwork
    linkedin
    hhru
  ).freeze

  SPECIFIC_SETTINGS_FIELDS = {
    upwork:   %i( rss_url ),
    linkedin: %i( api_key api_secret ),
    hhru:     %i( web_url username password )
  }.freeze

  COMMON_SETTINGS_FIELDS = %i( search_keys ).freeze

  def self.all_settings_fields
    (COMMON_SETTINGS_FIELDS + SPECIFIC_SETTINGS_FIELDS.values.flatten).uniq
  end

  enum :kind, KINDS, suffix: true, default: :upwork
  store_accessor :settings, all_settings_fields

  validates :name, :kind, presence: true
  validates :refresh_rate, presence: true, numericality: { greater_than: 20 }
  validate :kind_not_changed

  after_create :background_processing
  after_update :background_processing, if: -> { saved_change_to_refresh_rate? || saved_change_to_settings? }
  before_destroy :cancel_background_job

  belongs_to :user
  has_many :job_leads, dependent: :destroy

  scope :ordered, -> { order(id: :desc) }

  broadcasts_to ->(job_feed) { [job_feed.user, "job_feeds"] }, inserts_by: :prepend

  def settings_fields
    (COMMON_SETTINGS_FIELDS + SPECIFIC_SETTINGS_FIELDS[kind.to_sym]).uniq
  end

  private

  def kind_not_changed
    if kind_changed? && self.persisted?
      errors.add(:kind, "Change of kind not allowed!")
    end
  end

  def background_processing
    cancel_background_job

    bg_job = CollectJobLeadsJob.set(wait: refresh_rate.seconds).perform_later(id)
    bg_job && self.update_column(:background_job_id, bg_job.provider_job_id)
  end

  def cancel_background_job
    # TODO: add more logic when background_job is running
    if background_job_id.present?
      Sidekiq::Status.unschedule(background_job_id)
    end  
  end
end
