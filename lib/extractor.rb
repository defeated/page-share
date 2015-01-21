require 'nokogiri'

class Extractor
  attr_reader :content

  def initialize(content)
    @content = content
  end

  def extract!
    document = Nokogiri::HTML content do |config|
      config.noerror.nonet
    end

    title       = document.at('meta[@property="og:title"]/@content') ||
                  document.at('meta[@name="twitter:title"]/@content') ||
                  document.at('title/text()')

    description = document.at('meta[@property="og:description"]/@content') ||
                  document.at('meta[@name="twitter:description"]/@content') ||
                  document.at('meta[@name="description"]/@content')

    canonical   = document.at('link[@rel="canonical"]/@href') ||
                  document.at('meta[@property="og:url"]/@content')

    image       = document.at('meta[@property="og:image"]/@content') ||
                  document.at('meta[@name="twitter:image:src"]/@content')

    favicon     = document.at('link[@rel="shortcut icon"]/@href') ||
                  document.at('link[@rel="icon"]/@href')

    Page.new(
      title.to_s,
      description.to_s,
      canonical.to_s,
      image.to_s,
      favicon.to_s
    )
  end

  private

  Page = Struct.new(:title, :description, :canonical, :image, :favicon)
end
