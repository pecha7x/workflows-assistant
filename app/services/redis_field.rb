# https://rubydoc.info/gems/redis/Redis/
require 'redis'

class RedisField
  attr_reader :redis_conn, :key

  def initialize(key)
    @redis_conn = Redis.new(url: Rails.application.credentials.redis_url)
    @key = key
  end

  # rubocop:disable Style/CaseLikeIf
  def set_value(val, expires_in: nil)
    delete if exists?

    if val.is_a?(Hash)
      # Redis doesn't support nested hashes in general
      # so we just convert this to a string of JSON
      redis_conn.set(key, val.to_json)
      # redis.hset(key, val)
    elsif val.is_a?(Array)
      redis_conn.rpush(key, val)
    elsif val.is_a?(String)
      redis_conn.set(key, val)
    else
      raise "'#{val.class.name}' is not supported type of field by the adapter"
    end

    redis_conn.expire(key, expires_in) if expires_in.present?
  end
  # rubocop:enable Style/CaseLikeIf

  def value
    case redis_conn.type(key)
    when 'none'
      nil
    when 'string'
      val = redis_conn.get(key)
      valid_json?(val) ? JSON.parse(val) : val
    # when 'hash'
    #   redis_conn.hgetall(key)
    when 'list'
      redis_conn.lrange(key, 0, -1)
    else
      raise "'#{redis_conn.type(key)}' is not supported type of field by the adapter"
    end
  end

  def exists?
    redis_conn.exists?(key)
  end

  def delete
    redis_conn.del(key)
  end

  private

  def valid_json?(json)
    JSON.parse(json)
    true
  rescue JSON::ParserError, TypeError
    false
  end
end
