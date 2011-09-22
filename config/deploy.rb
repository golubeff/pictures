set :keep_releases, 2

# bundler bootstrap
require 'bundler/capistrano'
#require 'whenever/capistrano'
#set :whenever_command, "bundle exec whenever"

# main details
set :application, "pics.alfaproductionllc.com"
role :web, "pics.alfaproductionllc.com"
role :app, "pics.alfaproductionllc.com"
role :db,  "pics.alfaproductionllc.com", :primary => true

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

#task :dev do
  #set :deploy_to, "/opt/apps/glamfabs.com"
  #set :cap_env, 'dev'
#end

#task :prod do
  set :deploy_to, "/opt/apps/pics.alfaproductionllc.com"
  set :cap_env, 'prod'
#end


set :deploy_via, :remote_cache
set :user, "deploy"
set :use_sudo, false

# repo details
set :scm, :git
#set :scm_username, "ismackmanager"
set :repository, "git@github.com:golubeff/pictures.git"
set :git_enable_submodules, 1

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/login.rb #{release_path}/config/login.rb"
    run "ln -nfs #{shared_path}/system/ #{release_path}/public/system"
  end

  task :assets, :roles => :app do
    run "cd #{release_path} && bundle exec rake assets:clean"
    run "cd #{release_path} && bundle exec rake assets:precompile"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'
after "deploy:symlink", "deploy:migrate"
after "deploy:symlink", "deploy:assets"
deploy.task :restart, :roles => :app do
  #run "cd #{current_path} && rake queue:restart_workers RAILS_ENV=production"
  #run "sudo /etc/init.d/god restart"
  run "cd #{current_path} && touch tmp/restart.txt"
end

# log helpers
namespace :log do
  desc "Download production log into tmp/production_log"
  task :get, :role => [:app] do
    download "#{current_path}/log/production.log", 'tmp/production.log', :via => :scp
  end

  desc "Last items from production log in real-time"
  task :tail, :role => [:app] do
    stream "tail -f #{shared_path}/log/production.log"
  end

  desc "Last parameters from production log in real-time"
  task :tail_params, :role => [:app] do
    stream "tail -f #{shared_path}/log/production.log | grep --line-buffered Parameters"
  end
end

### BEFORE ###

# set :application, "set your application name here"
# set :repository,  "set your repository location here"
# 
# set :scm, :subversion
# # Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
# 
# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"
# 
# # If you are using Passenger mod_rails uncomment this:
# # if you're still using the script/reapear helper you will need
# # these http://github.com/rails/irs_process_scripts
# 
# # namespace :deploy do
# #   task :start do ; end
# #   task :stop do ; end
# #   task :restart, :roles => :app, :except => { :no_release => true } do
# #     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
# #   end
# # end

