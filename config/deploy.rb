# config valid only for current version of Capistrano
lock '3.19.2'

set :application, 'counters'
set :repo_url, 'git@github.com:glitchwrks/counters.git'
set :deploy_to, '/home/counters/counters'
set :keep_releases, 2

namespace :puma do
  desc 'Restart Puma server' 
  task :restart do  
    on roles(:web) do
      execute 'cd /home/counters/counters/current && RACK_ENV=production bundle exec pumactl phased-restart'
    end  
  end
end
