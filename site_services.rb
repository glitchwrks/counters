require 'sinatra/base'
require 'sinatra/activerecord'
require 'require_all'

require_all 'models'
require_all 'services'

class SiteServices < Sinatra::Base
  enable :logging
  set :port, '8080'

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
        redirect 'http://www.glitchwrks.com/contact/user_error.html'
      else
        redirect 'http://www.glitchwrks.com/contact/success.html'
      end
    rescue => exception
      logger.error "Exception thrown while sending a contact email"
      logger.error exception
      redirect 'http://www.glitchwrks.com/contact/server_error.html'
    end
  end

  post '/preorder/:project' do
    recaptcha_service = RecaptchaVerificationService.new
    recaptcha_service.action = 'preorder'
    recaptcha_service.response = params['g-recaptcha-response']
    recaptcha_service.address = request.ip

    redirect 'http://www.glitchwrks.com/xt-ide/preorder_error.html' unless recaptcha_service.execute

    processor = PreorderProcessorService.new
    processor.preorder = Preorder.new(params[:preorder].merge({:address => request.ip}))
    processor.project_name = params[:project]

    begin
      processor.execute

      if processor.errors.any?
        logger.error "*** DANGER *** Invalid project received: #{params[:project]} from #{request.ip}" if processor.invalid_project
        redirect 'http://www.glitchwrks.com/xt-ide/preorder_error.html'
      else
        redirect 'http://www.glitchwrks.com/xt-ide/preorder_success.html'
      end

    rescue => exception
      logger.error "Exception thrown while processing a preorder"
      logger.error exception
      redirect 'http://www.glitchwrks.com/xt-ide/preorder_server_error.html'
    end
  end

  get '/preorder/confirm/:token' do
    content_type :text

    preorder = Preorder.find_by(:confirmation_token => params[:token])

    unless preorder
      halt 404, 'Invalid confirmation token. Perhaps it has expired?'
    end

    preorder.becomes!(ConfirmedPreorder).save!
    redirect 'http://www.glitchwrks.com/xt-ide/preorder_confirmed.html'
  end

  run! if app_file == $0
end