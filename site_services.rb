require 'sinatra/base'
require 'sinatra/activerecord'
require 'require_all'

require_all 'models'

class SiteServices < Sinatra::Base

  get '/counters/:page' do
    counter = Counter.find_by(:name => params[:page])
    halt 404 unless counter.present?

    Hit.process_hit(request, counter)
    counter.javascript_hit_count(params[:ipv6])
  end

  run! if app_file == $0
end