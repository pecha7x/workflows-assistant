module TelegramBot
  module StartToken
    module Parameters
      class Handler
        attr_reader :parameters, :object

        def initialize(values)
          raise "#{values['object']} is not allowed for handle and process parameters" if values['object'].exclude?(APPLICABLE_CLASS_NAME_LIST)
          @parameters = values
        end

        def run
          object = parameters['object'].constantize.new
          object.assign_attributes(parameters['attributes'])
        end
      end
    end
  end
end
