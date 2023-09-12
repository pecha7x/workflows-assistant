module TelegramBot
  module StartToken
    module Parameters
      class Builder  
        attr_reader :values
        
        def initialize(object)
          raise "#{object.class.name} is not allowed for build parameters" if object.class.name.exclude?(APPLICABLE_CLASS_NAME_LIST)
          obtain_parameters(object)
        end
  
        private
  
        def obtain_parameters
          # add a more logic of obtain another models
          # currently only for Notifier, so is a pretty hardcoded   
          @values ||= {
            'object' => object.class.name,
            'attributes' => {
              'kind'       => 'telegram',
              'owner_id'   => object.owner_id,
              'owner_type' => object.owner_type
            }
          }
        end
      end
    end
  end
end
