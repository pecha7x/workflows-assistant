class JobLead
  module NotifiersProcessing
    extend ActiveSupport::Concern

    included do
      after_create :notify
    end

    private

    def notify
      notifiers.each do |notifier|
        NewJobLeadNotificationJob.set(wait: 2.seconds).perform_later(id, notifier.id)
      end
    end
  end
end
