require 'sinatra/base'
require 'sinatra/activerecord'
require 'require_all'

require_all 'models'

class Counters < Sinatra::Base
  enable :logging
  set :port, '8080'

  get '/counters/:name' do
    counter = Counter.find_by(:name => params[:name])
    halt 404 unless counter.present?

    Hit.process_hit(request, counter)
    content_type 'application/javascript'
    counter.javascript_hit_count(params[:ipv6])
  end

  run! if app_file == $0
end
