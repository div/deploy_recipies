set :private_pub_start,  "#{full_shared_path}/bin/private_pub_start.sh"
set :private_pub_pid, "#{full_shared_path}/pids/private_pub.pid"
set :private_pub_config, "#{full_current_path}/private_pub.ru"
set :private_pub_log, "#{full_current_path}/log/private_pub.log"


namespace :private_pub do
  desc "Setup Private Pub start scripts"
  task :setup do
    template "private_pub_start.sh.erb", private_pub_start
    queue "chmod +x #{private_pub_start}"
  end

  desc "Stop Private Pub"
  task :stop do
    queue "kill -9 `cat #{private_pub_pid}`"
    # queue "rm #{private_pub_pid}"
  end

  desc "Start Private Pub"
  task :start do
    queue private_pub_start
  end

  desc "Restart Private Pub"
  task :restart do
    invoke :'private_pub:stop'
    invoke :'private_pub:start'
  end
end