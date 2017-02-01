# environment variables
require 'dotenv'
Dotenv.load '.env'

# config valid only for current version of Capistrano
lock '3.7.1'

set :application, 'my100tales'
set :repo_url, 'https://github.com/yuzutas0/my100tales.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, '/var/www/my100tales'
set :deploy_via, :remote_cache

# Default value for :format is :airbrussh.
# set :format, :airbrussh
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true
set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"
set :linked_files, %w{.env}

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle vendor/assets public/system public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :keep_releases, 5

# capistrano/rbenv
# set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'

# Defaults to :db role
# Rails migrations are strictly related to the framework.
# Therefore, it's recommended to set the role to :app instead of :db
set :migration_role, :app

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }

# Defaults to false. If true, it's skip migration if files in db/migrate not modified
set :conditionally_migrate, true

# Connect unicorn
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_config_path, "#{release_path}/config/unicorn.rb"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create elasticsearch index'
  task :create_elasticsearch_index do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'elasticsearch:create_index'
        end
      end
    end
  end

  desc 'Clear cache'
  task :clear_cache do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :rake, 'tmp:cache:clear'
        end
      end
    end
  end

  before :publishing, 'assets:precompile'
  after :publishing, :restart
  after :restart, :clear_cache
  after :clear_cache, :create_elasticsearch_index
end

namespace :assets do
  desc 'Precompile assets locally and then rsync to web servers'
  task :precompile do
    run_locally do
      with rails_env: fetch(:stage) do
        execute 'bundle exec rake bower:install CI=true'
        execute 'bundle exec rake assets:precompile'
      end

      execute 'find ./public/assets/ -name "*.js" | xargs rm -f'
      execute 'find ./public/assets/ -name "*.css" | xargs rm -f'

      def rsync_command(path)
          'rsync' +
          + " --rsh='ssh -i /Users/#{ENV['LOCAL_USER']}/.ssh/#{ENV['RSA_FILE_NAME']} -p #{ENV['SSH_PORT']}'" +
          + " -av --delete ./#{path} #{ENV['OS_USER']}@#{ENV['SERVER_IP']}:#{shared_path}/#{path}"
      end

      execute rsync_command 'vendor/assets/bower_components/'
      execute rsync_command 'public/assets/'
      execute 'rm -rf public/assets'
    end
  end

  desc 'Extract assets at web servers'
  task :extract do
    on roles(:app) do
      within shared_path do
        execute :find, './public/assets/ -name "*.js.gz" | xargs gzip -d'
        execute :find, './public/assets/ -name "*.css.gz" | xargs gzip -d'
      end
    end
  end
  after :precompile, :extract
end
