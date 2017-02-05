# setup unicorn
namespace :unicorn do
  task :environment do
    set :unicorn_pid,    File.expand_path('tmp/pids/unicorn.pid', shared_path)
    set :unicorn_config, File.expand_path('config/unicorn/production.rb', current_path)
    set :unicorn_roles, -> { :app }
    set :unicorn_options, -> { '' }
    set :unicorn_rack_env, -> { :production }
  end

  def system_start
    execute :sudo, :systemctl, "start #{fetch(:application)}_unicorn"
  end

  def force_start
    within current_path do
      with rails_env: fetch(:rails_env) do
        execute :bundle, 'exec unicorn', '-c', fetch(:unicorn_config_path),
                '-E', fetch(:unicorn_rack_env), '-D', fetch(:unicorn_options)
      end
    end
  end

  def system_stop
    execute :sudo, :systemctl, "stop #{fetch(:application)}_unicorn"
  end

  def force_stop
    execute :kill, "$(< #{fetch(:unicorn_pid)})"
  end

  def system_restart
    execute :sudo, :systemctl, "restart #{fetch(:application)}_unicorn"
  end

  def system_reload
    execute :sudo, :systemctl, "reload #{fetch(:application)}_unicorn"
  end

  desc 'Stop unicorn server immediately'
  task force_stop: :environment do
    on roles(fetch(:unicorn_roles)) do
      force_stop
    end
  end

  desc 'Restart unicorn server by systemctl'
  task system_restart: :environment do
    on roles(fetch(:unicorn_roles)) do
      system_restart
    end
  end

  desc 'Restart unicorn server'
  task custom_restart: :environment do
    on roles(fetch(:unicorn_roles)) do
      invoke 'unicorn:stop'
      force_start
    end
  end
end
