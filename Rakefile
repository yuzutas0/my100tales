# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

if Rails.env.development?
  # emoji
  load 'tasks/emoji.rake'

  # rubocop
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  # rake => lint & test
  task(:default).clear
  task default: [:rubocop, :spec]
end
