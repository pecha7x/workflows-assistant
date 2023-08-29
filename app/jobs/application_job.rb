class ApplicationJob < ActiveJob::Base
  # https://api.rubyonrails.org/classes/ActiveJob/Core/ClassMethods.html#method-i-set
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  def log(message, severity = :info)
    BGProcessing.logger.send(severity, "#{self.class.name}.")
  end
end
