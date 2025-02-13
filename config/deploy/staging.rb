set :stage, :production
set :rack_env, :production

set :branch, :staging

set :default_env, { :path => "$HOME/.gem/ruby/3.3/bin:$PATH", :rack_env => :production }

server 'staging.bee.glitchworks.net', user: 'counters', roles: %w{app db web}, my_property: :my_value
set :linked_files, %w{config/database.yml}

task :reload_puma_service do
  on 'counters@staging.bee.glitchworks.net' do
    execute 'pumactl phased_restart'
  end
end
