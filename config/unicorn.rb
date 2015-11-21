app_path = '/home/services/site_services/current'

worker_processes 2
working_directory "#{app_path}/current"

timeout 30

listen '/var/www/run/unicorn/site_services.sock', :backlog => 64

pid '/var/run/unicorn/site_services.pid'

stderr_path '/var/log/unicorn/site_services_error.log'
stdout_path '/var/log/unicorn/site_services.log'

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end