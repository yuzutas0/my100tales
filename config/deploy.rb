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

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Bower install'
  task :bower_install do
    with rails_env: fetch(:rails_env) do
      within current_path do
        execute :bundle, :exec, :rake, 'bower:dsl:install'
      end
    end
  end

  desc 'Create elasticsearch index'
  task :create_elasticsearch_index do
    with rails_env: fetch(:rails_env) do
      within current_path do
        execute :bundle, :exec, :rake, 'elasticsearch:create_index'
      end
    end
  end

  desc 'Clear cache'
  task :clear_cache do
    on roles(:app) do
      execute :rake, 'cache:clear'
    end
  end

  # use 'bundle exec cap production deploy:db_create' only at first time
  desc 'Create Database'
  task :db_create do
    on roles(:db) do |_host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  before :publishing, 'assets:precompile'
  after :publishing, :clear_cache, :create_elasticsearch_index, :restart
end

namespace :assets do
  desc 'Precompile assets locally and then rsync to web servers'
  task :precompile do
    run_locally do
      with rails_env: fetch(:stage) do
        execute :rake, 'bower:install CI=true'
        execute :rake, 'assets:precompile'
      end

      def command(path)
        <<~EOS
          rsync --rsh="ssh -i ~/.ssh/#{ENV['RSA_FILE_NAME']} -p #{ENV['SSH_PORT']}" \
                -av --delete ./#{path} #{ENV['OS_USER']}@#{host.to_s}:#{shared_path}/#{path}
        EOS
      end

      execute command 'vendor/assets/bower_components/'
      execute command 'public/assets/'
      execute 'rm -rf public/assets'
    end
  end
end
