namespace :imagemagick do

  desc "Install the latest release of Imagemagick"
  task :install, roles: :app do
    run "#{sudo} apt-get install imagemagick libmagickwand-dev -y"
  end
  after "deploy:install", "imagemagick:install"
end