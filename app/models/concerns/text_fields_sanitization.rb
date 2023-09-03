module TextFieldsSanitization
  extend ActiveSupport::Concern

  included do
    columns.each do |column|
      next if column.type != :text

      define_method "sanitized_#{column.name}" do
        Kramdown::Document.new(send(column.name), input: 'html').to_kramdown
      end
    end
  end
end
