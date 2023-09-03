# == Schema Information
#
# Table name: job_sources
#
#  id                :bigint           not null, primary key
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint           not null
#  kind              :integer          default("simple")
#  refresh_rate      :integer          default(60)
#  settings          :jsonb
#  background_job_id :string
#
class JobSource < ApplicationRecord
  REFRESH_RATES = [ 30, 60, 120, 360 ].freeze

  KINDS = %i(
    simple
    website
    upwork
    linkedin
  ).freeze

  SPECIFIC_SETTINGS_FIELDS = {
    simple:   %i( web_url messenger_id ),
    website:  %i( web_url username password ),
    upwork:   %i( rss_url ),
    linkedin: %i( api_key api_secret )
  }.freeze

  def self.all_settings_fields
    SPECIFIC_SETTINGS_FIELDS.values.flatten.uniq
  end

  enum :kind, KINDS, suffix: true, default: :simple
  store_accessor :settings, all_settings_fields

  validates :name, :kind, :owner_country, presence: true
  validates :refresh_rate, presence: true, numericality: { greater_than: 20 }
  validate :kind_not_changed

  after_create :background_processing, if: -> { !simple_kind? }
  after_update :background_processing_in_later, if: -> { 
    !simple_kind? && (saved_change_to_refresh_rate? || saved_change_to_settings?)
  }
  before_destroy :cancel_background_job, if: -> { !simple_kind? }

  belongs_to :user
  has_many :job_leads, dependent: :destroy
  has_many :notifiers, as: :owner, dependent: :destroy

  scope :ordered, -> { order(id: :desc) }

  def settings_fields
    SPECIFIC_SETTINGS_FIELDS[kind.to_sym]
  end

  def background_processing(run_in_seconds=5)
    bg_job = CollectJobLeadsJob.set(wait: run_in_seconds.seconds).perform_later(id)
    bg_job && self.update_column(:background_job_id, bg_job.provider_job_id)
  end

  private

  def kind_not_changed
    if kind_changed? && self.persisted?
      errors.add(:kind, "Change of kind not allowed!")
    end
  end

  def background_processing_in_later
    cancel_background_job
    background_processing(refresh_rate.seconds)
  end

  def cancel_background_job
    # TODO: add more logic when background_job is running
    if background_job_id.present?
      Sidekiq::Status.unschedule(background_job_id)
    end  
  end
end
