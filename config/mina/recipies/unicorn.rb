set_default :unicorn_user,  user
set_default :unicorn_pid,  "#{full_shared_path}/tmp/pids/unicorn.pid"
set_default :unicorn_config,  "#{full_shared_path}/config/unicorn.rb"
set_default :unicorn_log,  "#{full_shared_path}/log/unicorn.log"
set_default :unicorn_workers, 4

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
    queue "mkdir -p #{shared_path}/config"
    template "unicorn.rb.erb", unicorn_config
    template "unicorn_init.erb", "/tmp/unicorn_init"
    queue "chmod +x /tmp/unicorn_init"
    queue "sudo mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}"
    queue "sudo update-rc.d -f unicorn_#{application} defaults"
  end
  #after "deploy:setup", "unicorn:setup"

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command => :environment do
      queue "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
end