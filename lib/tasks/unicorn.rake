# setup unicorn
namespace :unicorn do
  task :environment do
    set :unicorn_pid,    File.expand_path('tmp/pids/unicorn.pid', shared_path)
    set :unicorn_config, File.expand_path('config/unicorn/production.rb', current_path)
    set :unicorn_roles, -> { :app }
    set :unicorn_options, -> { '' }
    set :unicorn_rack_env, -> { :production }
  end

  def force_stop
    execute :kill, "$(< #{fetch(:unicorn_pid)})"
  end

  desc 'Restart unicorn server'
  task re_start: :environment do
    on roles(:app) do
      invoke 'unicorn:stop'
      invoke 'unicorn:start'
    end
  end

  desc 'Stop unicorn server immediately'
  task force_stop: :environment do
    on roles(:app) do
      force_stop
    end
  end
end
