namespace :whenever do
  task :start, :roles => :app do
    unless stage == "staging"
      run "cd #{current_path} && #{fetch(:runner)} whenever --update-crontab #{application} --set environment=#{fetch(:stage)}"
    end
  end
  after "deploy:restart", "whenever:start"
  after "deploy:start", "whenever:start"

  task :setup, :roles => :app do
    template "schedule.rb.erb", "#{shared_path}/config/schedule.rb"
  end
  after "deploy:setup", "whenever:setup"

  desc "Symlink the schedule.rb file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/schedule.rb #{release_path}/config/schedule.rb"
  end
  after "deploy:finalize_update", "whenever:symlink"
  
end

