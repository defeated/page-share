require 'spec_helper'
require 'cacher'

Cacheable = Struct.new :cache_key, :value

describe Cacher do
  before { @thing = Cacheable.new 'key', 'val' }

  it 'caches in memory' do
    @cache = Cacher.new
    @cache.set @thing, @thing.value
    @cache.get(@thing).must_equal @thing.value
  end

  it 'has an expiration' do
    @cache = Cacher.new expires_in: 0
    @cache.set @thing, @thing.value
    @cache.get(@thing).must_be_nil
  end

  it 'can be cleared' do
    @cache = Cacher.new
    @cache.set @thing, @thing.value
    @cache.clear
    @cache.get(@thing).must_be_nil
  end
end
