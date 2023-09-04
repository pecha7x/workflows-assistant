# == Schema Information
#
# Table name: job_leads
#
#  id            :bigint           not null, primary key
#  title         :string           not null
#  description   :text
#  link          :text             not null
#  potential     :integer          default("medium")
#  status        :integer          default("entry")
#  hourly_rate   :decimal(10, 2)   not null
#  job_source_id :bigint           not null
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_country :string           default("United States"), not null
#  external_id   :string           not null
#
class JobLead < ApplicationRecord
  include TextFieldsSanitization

  enum :status, %i[entry active detached], suffix: true, default: :entry
  enum :potential, %i[low medium high], suffix: true, default: :medium

  belongs_to :job_source
  has_many :notes, as: :owner, dependent: :destroy

  before_validation :generate_external_id, if: -> { !external_id? }

  validates :published_at, :description, :title, :link, :status, :potential, presence: true
  validates :hourly_rate, presence: true, numericality: { greater_than: 0 }
  validates :external_id, uniqueness: { scope: :job_source_id }

  delegate :user, to: :job_source

  scope :ordered, -> { order(published_at: :desc) }

  broadcasts_to ->(job_lead) { [job_lead.user, 'job_leads'] }, inserts_by: :prepend

  def formatted_title
    title.truncate(70, separator: /\s/, ommission: '....')
  end

  def next_lead_by_status(status_value = nil)
    leads_list = job_source.job_leads.where('published_at > ?', published_at)
    leads_list = leads_list.where(status: status_value) if status_value.present?
    leads_list.ordered.last
  end

  private

  def generate_external_id
    self.external_id = SecureRandom.urlsafe_base64
    generate_external_id if self.class.exists?(external_id:)
  end
end
