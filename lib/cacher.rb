require 'active_support'
require 'active_support/core_ext/numeric/conversions'
require 'active_support/cache'

# a simple in-memory cache. cacheable objects must implement :cache_key
class Cacher
  def initialize(options = {})
    @options = {
      expires_in:         24.hours,
      race_condition_ttl: 10.seconds
    }.merge options
    @client = ActiveSupport::Cache::MemoryStore.new @options
  end

  def get(request)
    client.read request.cache_key
  end

  def set(request, response)
    client.write request.cache_key, response
  end

  def clear
    client.clear
  end

  private

  attr_reader :client
end
