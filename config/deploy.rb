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

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/system vendor}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :keep_releases, 5

# capistrano/rbenv
# set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create Secret Key'
  task :create_secret_key do
    with rails_env: fetch(:rails_env) do
      within current_path do
        secret = capture 'bundle exec rake secret'
        execute "echo SECRET_KEY_BASE='#{secret}' > #{current_path}/.env"
        execute :bundle, :exec, :rake, 'elasticsearch:create_index'
      end
    end
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

  after :publishing, :clear_cache, :bower_install, :create_elasticsearch_index, :restart
end
