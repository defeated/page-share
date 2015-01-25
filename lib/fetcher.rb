require 'typhoeus'

class Fetcher
  attr_reader :url, :options

  def initialize(url, options = {})
    @url = url
    @options = {
      accept_encoding:  'gzip',
      followlocation:   true,
      connecttimeout:   3,
      timeout:          3,
      headers:          { 'User-Agent' => USER_AGENT }
    }.merge options
  end

  def fetch!
    response = Typhoeus.get url, options
    result = Result.new response.success?
    result.content = result.success? ? response.body : response.return_message
    result
  end

  private

  Result = Struct.new(:success?, :content)
  USER_AGENT = 'Mozilla/5.0 ;Windows NT 6.1; WOW64; AppleWebKit/537.36 ;KHTML, like Gecko; Chrome/39.0.2171.95 Safari/537.36'.freeze
end
