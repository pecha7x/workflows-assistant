module TelegramBot
  module StartToken
    module Parameters
      class Builder
        attr_reader :values

        def initialize(object)
          raise "'#{object.class.name}' is not allowed for build parameters" if APPLICABLE_MODEL_NAME_LIST.exclude?(object.class.name)

          obtain_parameters_from(object)
        end

        private

        def obtain_parameters_from(object)
          # add a more logic of obtain another models
          # currently only for Notifier, so is a pretty hardcoded
          @values = {
            'object' => object.class.name,
            'attributes' => {
              'id' => object.id
            }
          }
        end
      end
    end
  end
end
