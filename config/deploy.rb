require "bundler/capistrano"

load 'config/recipes/base.rb'
load 'config/recipes/nginx.rb'
load 'config/recipes/unicorn.rb'
load 'config/recipes/postgresql.rb'

server "198.211.121.192", :web, :app, :db, primary: true

puts "dupa"

task :staging do
  set :stage, "staging"
  set :unicorn_workers, 1
  set :nginx_server_name, "beta.kipscore.pl beta.kipscore.com"
end

task :production do
  set :stage, "production"
  set :unicorn_workers, 2
end

# Common variables
set :base_app_name, "kipscore"
set :application, "#{base_app_name}_#{fetch(:stage)}"
set :user, "deployer"
set :deploy_to, "/home/#{user}/app/#{fetch(:stage)}"
set :respository_name, "kipscore"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:blaziko/#{repository_name}.git"
set :branch, "master"

set :rails_env, fetch(:stage)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :runner, "RAILS_ENV=#{fetch(:stage)} bundle exec"

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end
