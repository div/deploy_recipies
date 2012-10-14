set :normal_symlinks, %w(
  database.yml
  s3.yml
  unicorn.rb
)

namespace :deploy do
  desc "Symlink shared resources on each release"
  task :symlink_shared, :roles => :app, :except => { :no_release => true } do
    commands = normal_symlinks.map do |file_name|
      "ln -nfs #{shared_path}/config/#{file_name} #{release_path}/config/#{file_name}"  
    end
    run <<-CMD
      cd #{release_path} &&
      #{commands.join(" && ")}
    CMD
  end
end
