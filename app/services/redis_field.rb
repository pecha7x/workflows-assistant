# https://rubydoc.info/gems/redis/Redis/
require 'redis'

class RedisField
  attr_reader :redis, :key

  def initialize(key)
    @redis = Redis.new(url: Rails.application.credentials.redis_url)
    @key = key
  end

  # rubocop:disable Style/CaseLikeIf
  def set_value(value, expires_in: nil)
    delete

    if value.is_a?(Hash)
      redis.hset(key, value)
    elsif value.is_a?(Array)
      redis.rpush(key, value)
    elsif value.is_a?(String)
      redis.set(key, value)
    else
      raise "'#{value.class.name}' is not supported type of field by the adapter"
    end

    redis.expire(key, expires_in) if expires_in.present?
  end
  # rubocop:enable Style/CaseLikeIf

  def value
    case redis.type(key)
    when 'none'
      nil
    when 'string'
      redis.get(key)
    when 'hash'
      redis.hgetall(key)
    when 'list'
      redis.lrange(key, 0, -1)
    else
      raise "'#{redis.type(key)}' is not supported type of field by the adapter"
    end
  end

  def delete
    redis.del(key)
  end

  def exists?
    redis.exists?(key)
  end
end
