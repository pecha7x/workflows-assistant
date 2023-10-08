module AssistantConfigurations
  class List
    def self.run(user)
      new(user:).configurations
    end

    attr_reader :user

    def initialize(user:)
      @user = user
    end

    def configurations
      AssistantConfiguration.descendants.map do |configuration|
        configuration.find_by(user:) || configuration.new
      end
    end
  end
end
