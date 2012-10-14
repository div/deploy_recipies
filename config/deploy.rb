#require "capistrano/ext/multistage"
require "bundler/capistrano"
require 'capistrano_colors'
require './config/boot'

set :default_environment, {
  'PATH' => "/home/dev/.rbenv/shims:/home/dev/.rbenv/bin:$PATH"
}

# set :stages, %w(production staging)
# set :default_stage, "staging"
set :user, "deployer"
set :application, "folify"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :branch, "origin/master"
server  "folify.com", :web, :app, :db, :primary => true, :resque=>true
set :scm, :git
set :repository,  "/home/deployer/git/folify"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :normalize_asset_timestamps, false
set :use_sudo, false
set :migrate_target, :current
set :ssh_options,     { :forward_agent => true }
set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }
set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

# basics
load 'config/recipes/base'

#daemons
#load 'config/recipes/mcached'
#load 'config/recipes/bndlr'
load 'config/recipes/resque'
load 'config/recipes/nginx'
load 'config/recipes/monit'
load 'config/recipes/redis'
load 'config/recipes/postgresql'
load 'config/recipes/memcached'

#installs
load 'config/recipes/rbenv'
load 'config/recipes/nodejs'
load 'config/recipes/libxml'
#load 'config/recipes/libcurl'
load 'config/recipes/imagemagick'

# deployment tasks
load 'config/recipes/git_deploy'
load 'config/recipes/symlinks'
load 'config/recipes/unicorn'
load 'config/recipes/assets'
load 'config/recipes/rollback'

# utils
# load 'config/recipes/db'
load 'config/recipes/log'

# hooks
#before "deploy:migrations", "database:dump"





