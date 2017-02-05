# setup unicorn
namespace :unicorn do
  task :environment do
    set :unicorn_pid,    File.expand_path('tmp/pids/unicorn.pid', shared_path)
    set :unicorn_config, File.expand_path('config/unicorn/production.rb', current_path)
    set :unicorn_roles, -> { :app }
    set :unicorn_options, -> { '' }
    set :unicorn_rack_env, -> { :production }
  end

  def force_start
    within current_path do
      with rails_env: fetch(:rails_env) do
        execute :bundle, 'exec unicorn', '-c', fetch(:unicorn_config_path),
                '-E', fetch(:unicorn_rack_env), '-D', fetch(:unicorn_options)
      end
    end
  end

  def force_stop
    execute :kill, "$(< #{fetch(:unicorn_pid)})"
  end

  desc 'Restart unicorn server'
  task re_start: :environment do
    on roles(fetch(:unicorn_roles)) do
      invoke 'unicorn:stop'
      force_start
    end
  end

  desc 'Stop unicorn server immediately'
  task force_stop: :environment do
    on roles(fetch(:unicorn_roles)) do
      force_stop
    end
  end
end
