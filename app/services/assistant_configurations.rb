class AssistantConfigurations
  def self.list(user)
    new(user:).list
  end

  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def list
    AssistantConfiguration.descendants.map do |configuration|
      configuration.find_by(user: user) || configuration.new
    end
  end
end
