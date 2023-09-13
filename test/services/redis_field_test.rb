require 'test_helper'

class RedisFieldTest < ActiveSupport::TestCase
  class HashField < RedisFieldTest
    setup do
      @key_value = { 'a' => '1', 'b' => '2' }
      @redis_field = RedisField.new('hash:key')
      @redis_field.set_value(@key_value)
    end

    teardown { @redis_field.delete }

    test 'should be success set a value' do
      assert_predicate(@redis_field, :exists?)
    end

    test 'should be success get a value' do
      assert_equal(@key_value, @redis_field.value)
    end

    test 'should be success delete a field' do
      @redis_field.delete

      assert_not_predicate(@redis_field, :exists?)
    end
  end

  class ArrayField < RedisFieldTest
    setup do
      @key_value = %w[a b c]
      @redis_field = RedisField.new('list:key')
      @redis_field.set_value(@key_value)
    end

    teardown { @redis_field.delete }

    test 'should be success set a value' do
      assert_predicate(@redis_field, :exists?)
    end

    test 'should be success get a value' do
      assert_equal(@key_value, @redis_field.value)
    end

    test 'should be success delete a field' do
      @redis_field.delete

      assert_not_predicate(@redis_field, :exists?)
    end
  end

  class StringField < RedisFieldTest
    setup do
      @key_value = 'new_value'
      @redis_field = RedisField.new('string:key')
      @redis_field.set_value(@key_value)
    end

    teardown { @redis_field.delete }

    test 'should be success set a value' do
      assert_predicate(@redis_field, :exists?)
    end

    test 'should be success get a value' do
      assert_equal(@key_value, @redis_field.value)
    end

    test 'should be success delete a field' do
      @redis_field.delete

      assert_not_predicate(@redis_field, :exists?)
    end
  end

  class FieldExpiration < RedisFieldTest
    setup do
      @expires_seconds = 1
      @key_value = 'new_value'
      @redis_field = RedisField.new('string:key')
      @redis_field.set_value(@key_value, expires_in: @expires_seconds.seconds)
    end

    teardown { @redis_field.delete }

    test 'should auto-removes the expired field' do
      assert_predicate(@redis_field, :exists?)
      sleep @expires_seconds

      assert_not_predicate(@redis_field, :exists?)
    end
  end

  class NonSupportedField < RedisFieldTest
    test 'should raise exception about unsupported' do
      redis_field = RedisField.new('symbol:key')
      error = assert_raises RuntimeError do
        redis_field.set_value(:symbol_value)
      end

      assert_equal "'Symbol' is not supported type of field by the adapter", error.message
    end
  end
end
