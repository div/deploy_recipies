namespace :rails do  
  desc "Displays the production log from the server locally"
  task :log, :roles => :app do
    stream "tail -f #{shared_path}/log/production.log"
  end
end