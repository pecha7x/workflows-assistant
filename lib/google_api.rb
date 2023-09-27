module GoogleApi
  def log(message, severity = :info)
    Rails.logger.send(severity, "#{self.class.name}. #{message}")
  end
end
