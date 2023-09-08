module NotifierProcessor
  class Email < Base
    def run
      JobLeadNotifierMailer.with(
        to_address: settings['address'],
        from_source_name: from,
        message_text: message,
        subject:,
        potential_color: potential_to_color
      ).new_lead_info.deliver_later
    end
  end
end
