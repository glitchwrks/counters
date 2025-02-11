set :stage, :production
set :rack_env, :production

set :branch, :puma_migration

set :default_env, { :path => "$HOME/.gem/ruby/2.3/bin:$PATH", :rack_env => :production }

server 'openbsd-test.map.glitchworks.net', user: 'counters', roles: %w{app db web}, my_property: :my_value
set :unicorn_rack_env, :production
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "/var/run/unicorn/site_services.pid"
set :linked_files, %w{config/database.yml}

after 'deploy', 'unicorn:reload'