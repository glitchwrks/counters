require 'sinatra/base'
require 'sinatra/activerecord'

Dir.glob(File.dirname(File.absolute_path(__FILE__)) + '/models/*', &method(:require))

class SiteServices < Sinatra::Base

  get '/counters/:page' do
    counter = Counter.find_by(:name => params[:page])
    halt 404 unless counter.present?

    Hit.process_hit(request, counter)
    counter.javascript_hit_count(params[:ipv6])
  end

  run! if app_file == $0
end