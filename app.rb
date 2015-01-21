require 'sinatra'
require 'json'
require './lib/fetcher'
require './lib/extractor'

enable :logging
disable :run
disable :sessions
disable :method_override
disable :static

post '/' do
  url = params[:u]
  result = Fetcher.new(url).fetch!

  if result.success?
    content_type :json
    details = Extractor.new(result.content).extract!
    details.to_h.to_json
  else
    status 500
    result.content
  end
end
