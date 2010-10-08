set :application, "lots_o_sites"
set :repository,  "ssh://foo.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/rails/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :user, :foo
set :scm_username, "fo"
set :use_sudo, false

role :app, "foo_server"
role :web, "foo_server"
role :db,  "foo_server", :primary => true

  # tell capistrano where all our configs are for each server
  mongrel_configs = []
  config_path = "#{deploy_to}/current/config"
  ls_result = capture("ls #{config_path}")
  ls_result.split(/\n/).each do |file|
    mongrel_configs << File.join(config_path, file) if file.include?("mongrel_cluster")
  end
  
  desc <<-DESC
  Start Mongrel processes on the app server.  This uses the :use_sudo variable to determine whether to use sudo or not. By default, :use_sudo is
  set to true.
  DESC
  task :start_mongrel_cluster , :roles => :app do
    mongrel_configs.each do |mongrel_conf|
      cmd = "mongrel_rails cluster::start -C #{mongrel_conf}"
      # cmd += " --clean" if mongrel_clean    
      send(run_method, cmd)
    end
  end
  
  desc <<-DESC
  Restart the Mongrel processes on the app server by starting and stopping the cluster. This uses the :use_sudo
  variable to determine whether to use sudo or not. By default, :use_sudo is set to true.
  DESC
  task :restart_mongrel_cluster , :roles => :app do
    mongrel_configs.each do |mongrel_conf|
      cmd = "mongrel_rails cluster::restart -C #{mongrel_conf}"
      # cmd += " --clean" if mongrel_clean    
      send(run_method, cmd)
    end
  end
  
  desc <<-DESC
  Stop the Mongrel processes on the app server.  This uses the :use_sudo
  variable to determine whether to use sudo or not. By default, :use_sudo is
  set to true.
  DESC
  task :stop_mongrel_cluster , :roles => :app do
    mongrel_configs.each do |mongrel_conf|
      cmd = "mongrel_rails cluster::stop -C #{mongrel_conf}"
      # cmd += " --clean" if mongrel_clean    
      send(run_method, cmd)
    end
  end

  desc <<-DESC
  Check the status of the Mongrel processes on the app server.  This uses the :use_sudo
  variable to determine whether to use sudo or not. By default, :use_sudo is
  set to true.
  DESC
  task :status_mongrel_cluster , :roles => :app do
    mongrel_configs.each do |mongrel_conf|
      send(run_method, "mongrel_rails cluster::status -C #{mongrel_conf}")
    end
  end
  
  desc <<-DESC
  Restart the Mongrel processes on the app server by calling restart_mongrel_cluster.
  DESC
  task :restart, :roles => :app do
    restart_mongrel_cluster
  end
  
  desc <<-DESC
  Override the deploy:restart so that it starts all the mongrel clusters
  DESC
  deploy.task :restart, :roles => :app do
    restart_mongrel_cluster
  end
  
  desc <<-DESC
  Override the deploy:stop so that it starts all the mongrel clusters
  DESC
  deploy.task :stop, :roles => :app do
    stop_mongrel_cluster
  end
  
  desc <<-DESC
  Override the deploy:restart so that it starts all the mongrel clusters
  DESC
  deploy.task :start, :roles => :app do
    start_mongrel_cluster
  end
  
  desc <<-DESC
  Start the Mongrel processes on the app server by calling start_mongrel_cluster.
  DESC
  task :spinner, :roles => :app do
    start_mongrel_cluster
  end
  
  desc <<-DESC
  Deploy and Start the Mongrel processes on the app server by calling start_mongrel_cluster.
  DESC
  task :deploy_mongrel_cluster, :roles => :app do
    deploy::update
    restart_mongrel_cluster
  end
  
  desc <<-DESC
  Relink shared resources that aren't being managed via git
  DESC
  deploy.task :relink_shared_resources, :roles => :app do
    %w{assets}.each do |share|
        run "ln -s #{shared_path}/#{share} #{release_path}/public/#{share}"
      end
  end
  
  desc <<-DESC
  Override the default deploy activity to inlude the creation of symbolic links to other assets that we dont' want it git
  DESC
  deploy.task :default do
    update
    relink_shared_resources
    restart
  end
    
  
  



