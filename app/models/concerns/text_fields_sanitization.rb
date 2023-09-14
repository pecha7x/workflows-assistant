module TextFieldsSanitization
  extend ActiveSupport::Concern
  delegate :strip_links, to: 'ActionController::Base.helpers'

  included do
    columns.each do |column|
      next if column.type != :text

      define_method "sanitized_#{column.name}" do |sanitize_links: false|
        text = send(column.name)
        text = strip_links(text) if sanitize_links
        text = Kramdown::Document.new(text, input: 'html').to_kramdown
        text
      end
    end
  end
end
