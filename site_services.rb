require 'sinatra/base'
require 'sinatra/activerecord'
require 'require_all'

require_all 'models'
require_all 'services'

class SiteServices < Sinatra::Base
  enable :logging

  get '/counters/:page' do
    counter = Counter.find_by(:name => params[:page])
    halt 404 unless counter.present?

    Hit.process_hit(request, counter)
    counter.javascript_hit_count(params[:ipv6])
  end

  post '/contact' do
    mailer = ContactMailerService.new
    mailer.message = Message.new(params[:message].merge({:address => request.ip}))

    begin
      mailer.execute

      if mailer.errors.any?
        redirect 'http://localhost:4000/contact/user_error.html'
      else
        redirect 'http://localhost:4000/contact/success.html'
      end
    rescue => exception
      logger.error "Exception thrown while sending a contact email"
      logger.error exception
      redirect 'http://localhost:4000/contact/server_error.html'
    end
  end

  run! if app_file == $0
end