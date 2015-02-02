require 'typhoeus'

# sets up a real looking user agent to efficiently fetch webpages
class Fetcher
  attr_reader :url, :options

  def self.cache=(provider)
    Typhoeus::Config.cache = provider
  end

  def initialize(url, options = {})
    @url = url
    @options = {
      accept_encoding:  'gzip',
      followlocation:   true,
      connecttimeout:   3,
      timeout:          3,
      headers:          { 'User-Agent' => DEFAULT_USER_AGENT }
    }.merge options
  end

  def fetch
    response = Typhoeus.get url, options
    Result.new response
  end

  private

  DEFAULT_USER_AGENT = 'Mozilla/5.0 ;Windows NT 6.1; WOW64; AppleWebKit/537.36 ;KHTML, like Gecko; Chrome/39.0.2171.95 Safari/537.36'.freeze

  # return document content on success, or error content on failure
  class Result
    attr_reader :success
    alias_method :success?, :success

    def initialize(response)
      @response, @success = response, response.success?
    end

    def content
      @content ||= success? ? response.body : response.return_message
    end

    private

    attr_reader :response
  end
end
