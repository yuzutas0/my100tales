# setup unicorn
namespace :unicorn do
  def force_stop
    execute :kill, "$(< #{fetch(:unicorn_pid)})"
  end

  desc 'Restart unicorn server gracefully'
  task restart: :environment do
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
