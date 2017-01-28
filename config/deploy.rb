# config valid only for current version of Capistrano
lock '3.7.1'

set :application, 'my100tales'
set :repo_url, 'https://github.com/yuzutas0/my100tales.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'master'
set :scm, :git

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
append :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/system vendor/bundle}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'}

# Default value for keep_releases is 5
# set :keep_releases, 5
set :keep_releases, 3

# capistrano/rbenv
# set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:legacy_restart'
  end
end
