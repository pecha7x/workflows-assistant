module AssistantConfigurations
  module Sync
    class Base
      attr_reader :assistant_configuration

      def initialize(assistant_configuration_id)
        @assistant_configuration = AssistantConfiguration.find(assistant_configuration_id)
      end

      def run
        raise 'Not implemented!'
      end

      private

      def log(message, severity = :info)
        BGProcessing.logger.send(severity, "#{self.class.name}. #{message}")
      end
    end
  end
end
