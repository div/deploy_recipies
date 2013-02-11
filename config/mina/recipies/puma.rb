set_default :puma_role, :app
set_default :puma_config,  "#{full_current_path}/config/puma.rb"
set_default :puma_pid,  "#{full_current_path}/pids/puma.pid"
set_default :puma_log,  "#{full_current_path}/log/puma.log"
set_default :puma_workers, 2

namespace :puma do

  desc "Setup Puma configuration"
  task :setup do
    queue "mkdir -p #{full_shared_path}/config"
    template "puma.erb", puma_config
  end

  desc "Start puma"
  task :start => :environment do
    queue "cd #{full_current_path} && bundle exec puma -C #{puma_config} >> #{puma_log}"
  end

  desc "Stop puma"
  task :stop do
    queue "kill -9 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})"
  end

  desc "Restart puma - zero downtime"
  task :restart do
    queue "kill -s USR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})"
    # queue "cd #{full_current_path} && bundle exec pumactl -S #{full_shared_path}/sockets/puma.state restart"
  end

  desc "Restart puma -force"
  task :force_restart do
    queue "kill -s USR2 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})"
  end

end
