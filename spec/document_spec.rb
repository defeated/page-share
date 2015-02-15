require 'spec_helper'
require 'extractor'

def html(content)
  parsed = Nokogiri::HTML(content) { |cfg| cfg.noerror.nonet }
  Extractor::Document.new parsed
end

describe Extractor::Document do
  it 'finds title' do
    html('<meta property="og:title" content="og" />').title.must_equal 'og'
    html('<meta name="twitter:title" content="tw" />').title.must_equal 'tw'
    html('<title>tag</title>').title.must_equal 'tag'
  end

  it 'finds description' do
    html('<meta property="og:description" content="og" />').description.must_equal 'og'
    html('<meta name="twitter:description" content="tw" />').description.must_equal 'tw'
    html('<meta name="description" content="tag" />').description.must_equal 'tag'
  end

  it 'finds canonical url' do
    html('<link rel="canonical" href="http://example.com" />').canonical.must_equal 'http://example.com'
    html('<meta property="og:url" content="http://og.example.com" />').canonical.must_equal 'http://og.example.com'
  end

  it 'finds main image' do
    html('<meta property="og:image" content="og.jpg" />').image.must_equal 'og.jpg'
    html('<meta name="twitter:image:src" content="tw.jpg" />').image.must_equal 'tw.jpg'
  end

  it 'finds favicon' do
    html('<link rel="shortcut icon" href="sh.jpg" />').favicon.must_equal 'sh.jpg'
    html('<link rel="icon" href="ico.jpg" />').favicon.must_equal 'ico.jpg'
  end
end
