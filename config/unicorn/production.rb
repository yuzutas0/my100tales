# -*- coding: utf-8 -*-
app_path = '/var/www/my100tales'
current_path = "#{app_path}/current"

working_directory "#{app_path}/current"
worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2) # 2-4 * CPU Core
preload_app true
timeout 15

listen '/tmp/unicorn.sock'
pid "#{app_path}/shared/tmp/pids/unicorn.pid"
stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{current_path}/Gemfile"
end

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
