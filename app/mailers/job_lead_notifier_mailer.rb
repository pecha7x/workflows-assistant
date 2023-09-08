class JobLeadNotifierMailer < ApplicationMailer
  NEW_LEADS_EMAIL_ADDRESS = 'new-leads@myworkflow.net'.freeze

  def new_lead_info
    return false if params[:to_address].blank? || params[:message_text].blank?

    from = Mail::Address.new(NEW_LEADS_EMAIL_ADDRESS)
    from.display_name = params[:from_source_name]

    @message_text = params[:message_text]
    @potential_color = params[:potential_color]

    mail(from:, to: params[:to_address], subject: params[:subject])
  end
end
