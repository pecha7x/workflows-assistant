module TelegramBot
  module StartToken
    module Parameters
      class Handler
        attr_reader :parameters, :object

        def initialize(values)
          raise "#{values['object']} is not allowed for handle and process parameters" if APPLICABLE_MODEL_NAME_LIST.exclude?(values['object'])

          @parameters = values
        end

        def run
          # add a more logic of obtain another models
          # currently only for Notifier, so is a pretty hardcoded
          @object = parameters['object'].constantize.find_by(parameters['attributes'])
        end
      end
    end
  end
end
