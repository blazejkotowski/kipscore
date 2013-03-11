namespace :nginx do
  task :setup
    template "nginx.conf", "/tmp/nginx.conf"
    run "#{sudo} mv /tmp/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
    restart
  end
  after "deploy:setup", "nginx:setup"
  
  
  %w[start stop restart].each do |cmd|
    desc "#{cmd}s nginx server"
    task cmd do
      run "#{sudo} service nginx #{cmd}"
    end
    after "deploy:#{cmd}", "nginx:#{cmd}"
  end
end
