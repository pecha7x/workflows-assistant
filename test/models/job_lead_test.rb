require 'test_helper'

class JobLeadTest < ActiveSupport::TestCase
  class Validations < JobLeadTest
    def job_lead_valid_attributes
      {
        title: 'Test',
        description: 'website',
        link: 'http://link.com',
        status: 'entry',
        potential: 'low',
        hourly_rate: 50.0,
        published_at: Time.current,
        job_source: job_sources(:first)
      }
    end

    test 'job lead should be valid' do
      job_lead = JobLead.new(job_lead_valid_attributes)
      assert job_lead.valid?
    end

    class Presence < Validations
      test 'title should be present' do
        job_lead = JobLead.new(job_lead_valid_attributes.merge(title: nil))
        assert job_lead.invalid?
        assert_has_errors_on job_lead, :title
      end

      test 'description should be present' do
        job_lead = JobLead.new(job_lead_valid_attributes.merge(description: nil))
        assert job_lead.invalid?
        assert_has_errors_on job_lead, :description
      end

      test 'link should be present' do
        job_lead = JobLead.new(job_lead_valid_attributes.merge(link: nil))
        assert job_lead.invalid?
        assert_has_errors_on job_lead, :link
      end

      test 'status should be present' do
        job_lead = JobLead.new(job_lead_valid_attributes.merge(status: nil))
        assert job_lead.invalid?
        assert_has_errors_on job_lead, :status
      end

      test 'potential should be present' do
        job_lead = JobLead.new(job_lead_valid_attributes.merge(potential: nil))
        assert job_lead.invalid?
        assert_has_errors_on job_lead, :potential
      end

      test 'published_at should be present' do
        job_lead = JobLead.new(job_lead_valid_attributes.merge(published_at: nil))
        assert job_lead.invalid?
        assert_has_errors_on job_lead, :published_at
      end

      test 'job_source should be present' do
        job_lead = JobLead.new(job_lead_valid_attributes.merge(job_source: nil))
        assert job_lead.invalid?
        assert_has_errors_on job_lead, :job_source
      end
    end

    class HourlyRate < Validations
      test 'hourly_rate should be present' do
        job_lead = JobLead.new(job_lead_valid_attributes.merge(hourly_rate: nil))
        assert job_lead.invalid?
        assert_has_errors_on job_lead, :hourly_rate
      end

      test 'hourly_rate should be greater than 0' do
        job_lead = JobLead.new(job_lead_valid_attributes.merge(hourly_rate: 0))
        assert job_lead.invalid?
        assert_has_errors_on job_lead, :hourly_rate
      end
    end

    class ExternalId < Validations
      test 'job lead should be valid with already been taken external_id but at another job_source_id scope' do
        job_lead_first = job_leads(:today_active)
        job_lead_second = job_lead_first.dup
        job_lead_second.job_source = job_sources(:second)
        assert job_lead_second.valid?
      end

      test 'external_id should be unique in job_source_id scope' do
        job_lead_first = job_leads(:today_active)
        job_lead_second = job_lead_first.dup
        assert job_lead_second.invalid?
        assert_has_errors_on job_lead_second, :external_id
      end
    end
  end

  class NextLead < JobLeadTest
    test "#next_lead_by_status returns the source's next lead when it exists" do
      assert_equal job_leads(:today), job_leads(:last_week).next_lead_by_status
    end

    test "#next_lead_by_status with status value returns the source's next lead when it exists" do
      assert_equal job_leads(:today_active), job_leads(:last_week).next_lead_by_status('active')
    end

    test '#next_lead_by_status returns nil when the source has no next leads' do
      assert_nil job_leads(:today_active).next_lead_by_status
    end
  end
end
