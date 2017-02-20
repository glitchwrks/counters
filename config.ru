require 'sinatra'
require 'rack/protection'

use Rack::Protection, :except => :json_csrf
root_dir = File.dirname(__FILE__)
app_file = File.join(root_dir, 'site_services.rb')
require app_file

set :environment, ENV['RACK_ENV'].to_sym
set :root,        root_dir
set :app_file,    app_file
disable :run

run SiteServices