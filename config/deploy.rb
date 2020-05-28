# config valid only for current version of Capistrano
lock '3.14.0'

set :application, 'site_services'
set :repo_url, 'git@github.com:chapmajs/site_services.git'
set :deploy_to, '/home/services/site_services'
set :keep_releases, 2
set :rvm_type, :user
set :rvm_ruby_version, '2.6.2@site_services'
