set :stage, :production
set :rack_env, :production

set :branch, :puma_migration

set :default_env, { :path => "$HOME/.gem/ruby/3.3/bin:$PATH", :rack_env => :production }

server 'openbsd-test.map.glitchworks.net', user: 'counters', roles: %w{app db web}, my_property: :my_value
set :linked_files, %w{config/database.yml}

# after 'deploy', 'puma:reload'