class ApplicationMailer < ActionMailer::Base
  default from: "'My Workflow' <noreply@myworkflow.net>"
  layout 'mailer'
end
