set(:unicorn_user) { user }
set(:unicorn_config) {"#{shared_path}/config/unicorn.rb"}
set(:unicorn_log) {"#{shared_path}/log/unicorn.log"}
set(:unicorn_pid) {"#{current_path}/tmp/pids/unicorn.pid"}
set_default(:unicorn_workers, 1)

namespace :unicorn do
  task :setup do
    template "unicorn.rb.erb", unicorn_config
    template "unicorn_init.sh.erb", "/tmp/unicorn_init"
    run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}"
    run "#{sudo} chmod +x /etc/init.d/unicorn_#{application}"
    run "#{sudo} update-rc.d -f unicorn_#{application} defaults"
  end
  after "deploy:setup", "unicorn:setup"
  
  %w[start stop restart].each do |cmd|
    desc "#{cmd}s unicorn server"
    task cmd do
      run "#{sudo} service unicorn_#{application} #{cmd}"
    end
    after "deploy:#{cmd}", "unicorn:#{cmd}"
  end
end
