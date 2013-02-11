task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/script"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/script"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/application.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/application.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/unicorn.rb"]
  queue  %[echo "-----> Be sure to edit 'shared/config/unicorn.rb'."]

  queue! %[touch "#{deploy_to}/shared/script/unicorn.sh"]
  queue! %[chmod u+x "#{deploy_to}/shared/script/unicorn.sh"]
  queue  %[echo "-----> Be sure to edit 'shared/script/unicorn.sh'."]
end