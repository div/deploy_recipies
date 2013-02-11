namespace :es do

  desc "Install the latest release of ElasticSearch"
  task :install, roles: :app do
    run "#{sudo} apt-get install openjdk-7-jre -y"
    run "wget https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.1.tar.gz -O elasticsearch.tar.gz"
    run "tar -xf elasticsearch.tar.gz"
    run "rm elasticsearch.tar.gz"
    run "#{sudo} mv elasticsearch-* elasticsearch"
    run "#{sudo} mv elasticsearch /usr/local/share"

    run "curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz"
    run "mv *servicewrapper*/service /usr/local/share/elasticsearch/bin/"
    run "rm -Rf *servicewrapper*"
    run "#{sudo} /usr/local/share/elasticsearch/bin/service/elasticsearch install"
    run "#{sudo} ln -s `readlink -f /usr/local/share/elasticsearch/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch"
  end
  after "deploy:install", "es:install"

  %w[start stop restart].each do |command|
    desc "#{command} elasticsearch"
    task command, roles: :web do
      run "#{sudo} service elasticsearch #{command}"
    end
  end

end