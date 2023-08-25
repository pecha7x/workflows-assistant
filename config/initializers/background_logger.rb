class BGProcessing
  def self.logger
    Logger.new(File.join(Rails.root, 'log', "bg_processing_#{Rails.env}.log"))
  end
end
