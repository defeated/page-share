require 'sinatra'
require 'json'
require 'base64'
require './lib/cacher'
require './lib/fetcher'
require './lib/extractor'

configure do
  enable :logging
  disable :run
  disable :sessions
  disable :method_override
  disable :static

  Fetcher.cache = Cacher.new
end

get '/:encoded_url' do
  url = Base64.decode64 params[:encoded_url]
  result = Fetcher.new(url).fetch!

  if result.success?
    details = Extractor.new(result.content).extract!
    payload = details.to_h.to_json

    if callback = params[:callback]
      content_type :js
      "#{ callback }( #{ payload } )"
    else
      content_type :json
      payload
    end
  else
    status 500
    result.content
  end
end
