require 'typhoeus'

class Fetcher
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def fetch!
    options = {
      followlocation: true,
      timeout:        2,
      connecttimeout: 2,
      headers:        { 'User-Agent' => USER_AGENT }
    }

    response = Typhoeus.get url, options

    result = Result.new response.success?
    result.content = result.success? ? response.body : response.return_message
    result
  end

  private

  Result = Struct.new(:success?, :content)
  USER_AGENT = 'Mozilla/5.0 ;Windows NT 6.1; WOW64; AppleWebKit/537.36 ;KHTML, like Gecko; Chrome/39.0.2171.95 Safari/537.36'.freeze
end
