require 'test_helper'

class JobLeadNotifierMailerTest < ActionMailer::TestCase
  class NewLeadInfo < JobLeadNotifierMailerTest
    def setup
      @params = {
        to_address: 'user@email.to',
        message_text: 'New Job Lead description',
        subject: 'Subject'
      }
    end

    test 'should deliver email once' do
      email = JobLeadNotifierMailer.with(@params).new_lead_info

      assert_emails 1 do
        email.deliver_later
      end
    end

    test 'from address and to address should be expected' do
      email = JobLeadNotifierMailer.with(@params).new_lead_info

      assert_equal email.to, [@params[:to_address]]
      assert_equal email.from, [JobLeadNotifierMailer::NEW_LEADS_EMAIL_ADDRESS]
    end

    test 'subject and message should be expected' do
      email = JobLeadNotifierMailer.with(@params).new_lead_info

      assert_equal email.subject, @params[:subject]
      assert_match 'Hey, there are a new job lead! Check and send the apply ASAP', email.body.encoded
      assert_match @params[:message_text], email.body.encoded
    end
  end
end
