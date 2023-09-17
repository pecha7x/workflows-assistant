module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.prepend 'flash', partial: 'layouts/flash'
  end

  def form_server_error_notification(object)
    return unless object.errors.any?

    tag.div class: 'error-message' do
      object.errors.full_messages.to_sentence.capitalize
    end
  end

  #
  # next generates the code:
  #
  # link_to "Action",
  #         resource_path(resource),
  #         data: {
  #           turbo_method: turbo_method,
  #           controller:   "confirmation",
  #           message:      "Are you sure?",
  #           action:       "click->confirmation#confirm"
  #         }
  #
  def confirmation_link_to(*args, &block)
    if block
      options      = args.first || {}
      html_options = args.second
      confirmation_link_to(capture(&block), options, html_options)
    else
      data_confirmation_attrs = {
        turbo_method: :get,
        controller: 'confirmation',
        message: 'Are you sure?',
        action: 'click->confirmation#confirm'
      }
      name         = args[0]
      options      = args[1] || {}
      html_options = args[2] || {}

      html_options[:data] = html_options[:data] ? data_confirmation_attrs.merge(html_options[:data]) : data_confirmation_attrs

      link_to(name, options, html_options)
    end
  end

  # rubocop:disable Rails/OutputSafety
  def collapsible(visible_height_rem: 2.0, class_name: '', &block)
    html = <<-HTML
      <div class="collapsible #{class_name}" data-controller="collapsible">
        <div class="collapsible-visible"
             style="--visible-height: #{visible_height_rem}rem;"
             data-visible-height-rem="#{visible_height_rem}"
             data-collapsible-target="element">
          #{capture(&block)}
        </div>
        <div class="collapsible-button collapsible-button-hidden"
             data-collapsible-target="button"
             data-action="click->collapsible#toggle_visibility">
          <i class="fas fa-angles-down fa-xl" data-collapsible-target="buttonIcon"></i>
        </div>
      </div>
    HTML

    html.html_safe
  end
  # rubocop:enable Rails/OutputSafety
end
