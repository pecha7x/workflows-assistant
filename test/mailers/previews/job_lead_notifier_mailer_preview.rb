# Preview all emails at http://localhost:3000/rails/mailers/job_lead_notifier_mailer
class JobLeadNotifierMailerPreview < ActionMailer::Preview
  def new_lead_info
    JobLeadNotifierMailer.with(
      to_address: 'user@email.to',
      from_source_name: 'Job Source Name',
      message_text: 'New Job Lead description',
      subject: 'Subject',
      potential_color: 'red'
    ).new_lead_info
  end
end
