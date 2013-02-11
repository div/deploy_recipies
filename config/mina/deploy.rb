$:.unshift './config'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)

# set :default_environment, {
#   'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH"
# }
set :application, "mycoolapp"
set :user, "deployer"
set :domain, 'mycoolapp.com'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :repository,  "/home/#{user}/git/#{application}"
set :branch, 'master'

set :full_current_path, "#{deploy_to}/#{current_path}"
set :full_shared_path, "#{deploy_to}/#{shared_path}"

set :shared_paths, ['config/database.yml', 'log', 'pids', 'sockets', 'config/application.yml',
  'config/sidekiq.yml', 'config/private_pub.yml', 'config/puma.rb', 'config/private_pub.yml']


task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  invoke :'rbenv:load'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[-----> Be sure to edit 'shared/config/database.yml'.]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'puma:restart'
      invoke :'sidekiq:restart'
      invoke :'private_pub:stop'
    end
  end
end

require 'mina/recipies/base'
require 'mina/recipies/setup'
require 'mina/recipies/puma'
require 'mina/recipies/sidekiq'
require 'mina/recipies/private_pub'
require 'mina/recipies/monit'