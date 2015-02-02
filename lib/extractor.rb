require 'nokogiri'

# attempts to extract meaningful metadata from an html document
class Extractor
  attr_reader :content

  def initialize(content)
    @content = content
  end

  def extract
    parsed = Nokogiri::HTML content { |cfg| cfg.noerror.nonet }
    Document.new parsed
  end

  private

  # contains all attribute search heuristics for an html document
  class Document
    def initialize(document)
      @document = document
    end

    def to_h
      {
        title:        title,
        description:  description,
        canonical:    canonical,
        image:        image,
        favicon:      favicon
      }
    end

    def title
      @title ||= find_first(
        'meta[@property="og:title"]/@content',
        'meta[@name="twitter:title"]/@content',
        'title/text()'
      )
    end

    def description
      @description ||= find_first(
        'meta[@property="og:description"]/@content',
        'meta[@name="twitter:description"]/@content',
        'meta[@name="description"]/@content'
      )
    end

    def canonical
      @canonical ||= find_first(
        'link[@rel="canonical"]/@href',
        'meta[@property="og:url"]/@content'
      )
    end

    def image
      @image ||= find_first(
        'meta[@property="og:image"]/@content',
        'meta[@name="twitter:image:src"]/@content'
      )
    end

    def favicon
      @favicon ||= find_first(
        'link[@rel="shortcut icon"]/@href',
        'link[@rel="icon"]/@href'
      )
    end

    private

    def find_first(*xpaths)
      xpaths.inject(nil) do |result, xpath|
        result = @document.at xpath
        break result if result
      end.to_s
    end
  end
end
