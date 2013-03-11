require "bundler/capistrano"

server "198.211.121.192", :web, :app, :db, primary: true

task :staging do
  set :stage, "staging"
  set :unicorn_workers, 1
  set :nginx_server_name, "beta.kipscore.pl beta.kipscore.com kipscore.vps"
end

task :production do
  set :stage, "production"
  set :server_name, false
  set :unicorn_workers, 2
  set :nginx_server_name, false
end

# Common variables
set :base_app_name, "kipscore"
set(:application) { "#{fetch(:base_app_name)}_#{fetch(:stage)}" }
set :user, "deployer"
set(:deploy_to) { "/home/#{fetch(:user)}/app/#{fetch(:stage)}" }
set :repository_name, "kipscore"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set(:repository) { "git@github.com:blaziko/#{fetch(:repository_name)}.git" }
set :branch, "master"

set :bundle_flags, "--deployment --quiet --binstubs"

set(:rails_env) { fetch(:stage) }

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set(:runner) { "RAILS_ENV=#{fetch(:stage)} bundle exec"}


load 'config/recipes/base.rb'
load 'config/recipes/nginx.rb'
load 'config/recipes/unicorn.rb'
load 'config/recipes/postgresql.rb'


after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  desc "Create necessary directories to perform setup"
  task :create_directories do
    run "mkdir -p #{shared_path}/config"
  end  
  before "deploy:setup", "deploy:create_directories"
  
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
    
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
