namespace :libcurl do

  desc "Install the latest release of libcurl"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install curl libcurl3 libcurl3-dev"
  end
  after "deploy:install", "libcurl:install"

end