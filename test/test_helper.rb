ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'
require 'minitest/spec'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def assert_has_errors_on(record, *fields)
      unmatched = record.errors.attribute_names - fields.flatten

      assert_predicate unmatched, :blank?, "#{record.class} has errors on '#{unmatched.join(', ')}'"
      unmatched = fields.flatten - record.errors.attribute_names

      assert_predicate unmatched, :blank?, "#{record.class} doesn't have errors on '#{unmatched.join(', ')}'"
    end
  end
end
