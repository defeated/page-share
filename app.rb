require 'sinatra/base'
require 'json'
require 'base64'
require './lib/cacher'
require './lib/fetcher'
require './lib/extractor'
require './lib/etagger'

class PageShareApp < Sinatra::Base
  configure do
    enable :logging
    Fetcher.cache = Cacher.new
  end

  get '/:encoded_url' do
    url = Base64.decode64 params[:encoded_url]
    result = Fetcher.new(url).fetch!

    halt 500, result.content unless result.success?

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
  end
end
