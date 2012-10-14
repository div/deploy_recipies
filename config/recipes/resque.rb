set_default(:resque_start) { "#{shared_path}/bin/start_resque.sh" }
set_default(:resque_scheduler_start) { "#{shared_path}/bin/start_resque_scheduler.sh" }

namespace :resque do
  desc "Setup Resque start scripts"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/bin"
    
    template "start_resque.sh.erb", resque_start
    run "chmod +x #{resque_start}"

    template "start_resque_scheduler.sh.erb", resque_scheduler_start
    run "chmod +x #{resque_scheduler_start}"
  end
  after "deploy:setup", "resque:setup"

  desc "After deploy:restart we want to restart the workers"
  task :restart, :roles => [:app], :only => {:resque => true} do
    #run "monit restart all -g resque_#{application}"
    run "cd #{current_path} && bundle exec rake resque:restart RAILS_ENV=#{rails_env}"
  end

  after 'deploy:restart', 'resque:restart'
end

