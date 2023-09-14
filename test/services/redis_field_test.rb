require 'test_helper'

class RedisFieldTest < ActiveSupport::TestCase
  def create_field(key, value)
    redis_field = RedisField.new(key)
    redis_field.set_value(value)
    redis_field
  end

  class HashField < RedisFieldTest
    teardown { @redis_field.delete }

    test 'should be success set a value' do
      @redis_field = create_field('hash:key:1', { 'a' => '1', 'b' => '2' })

      assert_predicate(@redis_field, :exists?)
    end

    test 'should be success get a value' do
      value = { 'a' => '1', 'b' => '2' }
      @redis_field = create_field('hash:key:2', value)

      assert_equal(value, @redis_field.value)
    end

    test 'should be success delete a field' do
      key = 'hash:key:3'
      @redis_field = create_field(key, { 'a' => '1', 'b' => '2' })
      @redis_field.delete

      assert_not_predicate(@redis_field, :exists?)
    end
  end

  class ArrayField < RedisFieldTest
    teardown { @redis_field.delete }

    test 'should be success set a value' do
      @redis_field = create_field('list:key:1', %w[a b c])

      assert_predicate(@redis_field, :exists?)
    end

    test 'should be success get a value' do
      value = %w[a b c]
      @redis_field = create_field('list:key:2', value)

      assert_equal(value, @redis_field.value)
    end

    test 'should be success delete a field' do
      key = 'list:key:3'
      @redis_field = create_field(key, %w[a b c])
      @redis_field.delete

      assert_not_predicate(@redis_field, :exists?)
    end
  end

  class StringField < RedisFieldTest
    teardown { @redis_field.delete }

    test 'should be success set a value' do
      @redis_field = create_field('string:key:1', 'new_value')

      assert_predicate(@redis_field, :exists?)
    end

    test 'should be success get a value' do
      value = 'new_value'
      @redis_field = create_field('string:key:2', value)

      assert_equal(value, @redis_field.value)
    end

    test 'should be success delete a field' do
      key = 'string:key:3'
      @redis_field = create_field(key, 'new_value')
      @redis_field.delete

      assert_not_predicate(@redis_field, :exists?)
    end
  end

  class FieldExpiration < RedisFieldTest
    setup do
      @expires_seconds = 2
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
