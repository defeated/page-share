require 'sinatra'
require 'json'
require 'base64'
require './lib/cacher'
require './lib/fetcher'
require './lib/extractor'
require './lib/etagger'

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
    type    = :json
    payload = details.to_h.to_json
    key     = "#{ url }:#{ payload }"

    if callback = params[:callback]
      type = :js
      payload = "#{ callback }( #{ payload } );"
    end

    content_type type
    expires 5.minutes, :public, :must_revalidate
    etag Etagger.new(key).hash
    payload
  else
    status 500
    result.content
  end
end
