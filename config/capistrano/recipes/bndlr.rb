namespace :bundler do
  desc "Symlink bundled gems on each release"
  task :symlink_bundled_gems, :roles => :app do
    run "mkdir -p #{shared_path}/bundled_gems"
    run "ln -nfs #{shared_path}/bundled_gems #{release_path}/vendor/bundle"
  end

  desc "Install for production"
  task :install, :roles => :app do
    from = source.next_revision(previous_revision)
    if capture("cd #{latest_release} && #{source.local.log(from)} Gemfile.lock | wc -l").to_i > 0
      run %Q{cd #{release_path} && bundle install --deployment --without development test}
    else
      logger.info "Skipping bundle install because there were no changes in Gemfile.lock"
    end
  end
end