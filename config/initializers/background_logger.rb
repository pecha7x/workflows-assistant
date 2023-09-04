class BGProcessing
  def self.logger
    Logger.new(Rails.root.join('log', "bg_processing_#{Rails.env}.log").to_s)
  end
end
