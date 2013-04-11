namespace :app do

  desc "Displays the production log from the server locally"
  task :log, :roles => :app do
    stream "tail -f #{shared_path}/log/production.log"
  end

  desc "Open the rails console on one of the remote servers"
  task :console, :roles => :app do
    exec %{ssh #{domain} -t "#{default_shell} -c 'cd #{current_path} && bundle exec rails c #{rails_env}'"}
  end

  desc "remote rake task"
  task :rake do
    run "cd #{deploy_to}/current; RAILS_ENV=#{rails_env} rake #{ENV['TASK']}"
  end
end