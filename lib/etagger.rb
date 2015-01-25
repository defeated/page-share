require 'zlib'

class Etagger
  def initialize(thing)
    @thing = thing
  end

  def hash
    Zlib.crc32(thing.to_s).to_s
  end

  private

  attr_reader :thing
end
