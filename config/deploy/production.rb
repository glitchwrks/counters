set :stage, :production
set :rack_env, :production

set :default_env, { :path => "$HOME/.gem/ruby/2.2/bin:$PATH", :rack_env => :production }

server 'services.theglitchworks.net', user: 'services', roles: %w{app db web}, my_property: :my_value
set :unicorn_rack_env, :production
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "/var/run/unicorn/site_services.pid"
set :linked_files, %w{config/database.yml config/email.yml config/recaptcha.yml}

after 'deploy', 'unicorn:reload'