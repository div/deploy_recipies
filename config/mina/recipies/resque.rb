set_default :resque_start,  "#{full_shared_path}/script/start_resque.sh"
set_default :resque_scheduler_start, "#{full_shared_path}/script/start_resque_scheduler.sh"

namespace :resque do
  desc "Setup Resque start scripts"
  task :setup do
    queue "mkdir -p #{full_shared_path}/script"

    template "start_resque.sh.erb", resque_start
    queue "chmod +x #{resque_start}"

    template "start_resque_scheduler.sh.erb", resque_scheduler_start
    queue "chmod +x #{resque_scheduler_start}"
  end

  desc "After deploy:restart we want to restart the workers"
  task :restart => :environment do
    queue "cd #{full_current_path} && bundle exec rake resque:restart RAILS_ENV=#{rails_env}"
  end
end

