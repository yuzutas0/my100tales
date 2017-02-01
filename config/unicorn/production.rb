# -*- coding: utf-8 -*-
app_path = '/var/www/my100tales'
shared_path = "#{app_path}/shared"
current_path = "#{app_path}/current"

working_directory current_path
worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2) # 2-4 * CPU Core
preload_app true
timeout 15

listen File.expand_path('tmp/sockets/unicorn.sock', shared_path)
pid File.expand_path('tmp/pids/unicorn.pid', shared_path)

stderr_path File.expand_path('log/unicorn.stderr.log', shared_path)
stdout_path File.expand_path('log/unicorn.stdout.log', shared_path)

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
