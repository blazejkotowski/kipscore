set_default(:unicorn_config, "#{current_path}/config/unicorn.rb")
set_default(:unicorn_log, "#{current_path}/log/unicorn.log")
set_default(:unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid")
set_default(:unicorn_workers, 1)

namespace :unicorn do
  task :setup do
    template "unicorn.rb", unicorn_config
    template "unicorn_init.sh", "/tmp/unicorn_init"
    run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{fetch(:application)}"
    run "#{sudo} chmod +x /etc/init.d/unicorn_#{fetch(:application)}"
    run "#{sudo} update-rc.d -f unicorn_#{fetch(:application)} defaults"
    start
  end
  after "deploy:setup", "unicorn_setup"
  
  %[start stop restart].each do |cmd|
    desc "#{cmd}s unicorn server"
    task cmd do
      run "#{sudo} service unicorn_#{fetch(:application)} #{cmd}"
    end
    after "deploy:#{cmd}", "unicorn:#{cmd}"
  end
end
