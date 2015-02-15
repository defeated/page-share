require 'zlib'

# generates a unique string identifier using zlib crc32 checksum algorithm.
class Etagger
  def initialize(thing)
    @thing = thing
  end

  def tag
    Zlib.crc32(@thing.to_s).to_s
  end
end
