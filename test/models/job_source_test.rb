require 'test_helper'

class JobSourceTest < ActiveSupport::TestCase
  class Callbacks < JobSourceTest
    class BackgroundProcessing < Callbacks
      class CreateBackgroundJob < BackgroundProcessing
        test "after_create doesn't call the processing when kind is 'simple'" do
          job_source = JobSource.new(kind: 'simple', name: 'Test', user: users(:user1))
          assert_called(job_source, :background_processing, times: 0) do
            job_source.save
          end
        end

        test "after_save doesn't call the processing when kind is 'simple'" do
          job_source = JobSource.create(kind: 'simple', name: 'Test', user: users(:user1))
          job_source.web_url = 'https://example.com'
          assert_called(job_source, :background_processing, times: 0) do
            job_source.save
          end
        end

        test "after_create does call the processing when kind is not 'simple'" do
          job_source = JobSource.new(kind: 'website', name: 'Test', user: users(:user1))
          assert_called(job_source, :background_processing, times: 1) do
            job_source.save
          end
        end

        test "after_save does call the processing when kind is not 'simple'" do
          job_source = JobSource.create(kind: 'website', name: 'Test', user: users(:user1))
          job_source.username = 'test_username'
          assert_called(job_source, :background_processing, times: 1) do
            job_source.save
          end
        end
      end

      class CancelBackgroundJob < BackgroundProcessing
        include ActiveSupport::Testing::MethodCallAssertions

        test "before_destroy does call the processing when kind is not 'simple'" do
          job_source = JobSource.new(kind: 'website', name: 'Test', user: users(:user1))
          job_source.save
          assert_called(job_source, :cancel_background_job, times: 1) do
            job_source.destroy
          end
        end
      end
    end
  end

  class Validations < JobSourceTest
    test 'job source should be valid' do
      job_source = JobSource.new(name: 'Test', kind: 'website', user: users(:user1))

      assert_predicate job_source, :valid?
    end

    class Presence < Validations
      test 'name should be present' do
        job_source = JobSource.new(name: nil, kind: 'website', user: users(:user1))

        assert_predicate job_source, :invalid?
        assert_has_errors_on job_source, :name
      end

      test 'kind should be present' do
        job_source = JobSource.new(name: 'Test', kind: '', user: users(:user1))

        assert_predicate job_source, :invalid?
        assert_has_errors_on job_source, :kind
      end

      test 'user should be present' do
        job_source = JobSource.new(name: 'Test', kind: 'website', user: nil)

        assert_predicate job_source, :invalid?
        assert_has_errors_on job_source, :user
      end
    end

    class RefreshRate < Validations
      test 'refresh_rate should be present' do
        job_source = JobSource.new(name: 'Test', kind: 'website', refresh_rate: nil, user: users(:user1))

        assert_predicate job_source, :invalid?
        assert_has_errors_on job_source, :refresh_rate
      end

      test 'refresh_rate should be greater than 20' do
        job_source = JobSource.new(name: 'Test', kind: 'website', refresh_rate: 19, user: users(:user1))

        assert_predicate job_source, :invalid?
        assert_has_errors_on job_source, :refresh_rate
      end
    end

    class KindNotChanged < Validations
      test 'change of kind not allowed' do
        job_source = job_sources(:first)
        job_source.kind = 'upwork'

        assert_predicate job_source, :invalid?
        assert_has_errors_on job_source, :kind
      end
    end
  end
end
