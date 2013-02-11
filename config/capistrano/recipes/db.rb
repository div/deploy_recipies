namespace :database do
  desc "Download database"
  task :mirror do

    datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    dump_file = File.join("tmp", "#{datestamp}_dump.sql")

    run "cd #{current_path}; RAILS_ENV=production bundle exec rake db:dump"
    `scp dev@dev3.workisfun.ru:#{current_path}/dump/database/last_dump.sql.gz #{dump_file}.gz`
    `gunzip #{dump_file}.gz`

    db_config = YAML.load(File.new("config/database.yml", "r"))["development"]
    `mysql -u #{db_config['username']} --password=#{db_config['password']} #{db_config['database']} < #{dump_file}`

  end

  desc "Dump database"
  task :dump do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake db:dump"
  end
end
