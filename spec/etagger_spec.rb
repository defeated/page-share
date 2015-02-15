require 'spec_helper'
require 'etagger'

describe Etagger do
  it 'hashes a string' do
    Etagger.new("abc").tag.must_equal '891568578'
  end
end
