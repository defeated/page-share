require 'zlib'

class Etagger
  def initialize(thing)
    @thing = thing
  end

  def tag
    Zlib.crc32(@thing.to_s).to_s
  end
end
