source 'https://rubygems.org'

# Base
gem 'rails', '4.2.6'
gem 'sdoc', '~> 0.4.0', group: :doc # TODO: document

# ENV
gem 'dotenv-rails'

# M/W
gem 'mysql2'
gem 'redis-rails'
gem 'elasticsearch-rails'
gem 'elasticsearch-model'

# SQL Performance
gem 'activerecord-import'

# AP
gem 'jbuilder', '~> 2.0'
gem 'devise'

# FILE
gem 'rubyzip'

# View
gem 'font-awesome-rails'
gem 'kaminari'
gem 'redcarpet'
gem 'gemoji'
gem 'data-confirm-modal'

# Stylesheet
gem 'sass-rails', '~> 5.0'
gem 'honoka-rails' # gem 'bootstrap-sass'

# JavaScript
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'vuejs-rails'
gem 'bower-rails'

# View Performance
gem 'turbolinks'

# View Log
gem 'quiet_assets'

# View Locale
gem 'rails-i18n', github: 'svenfuchs/rails-i18n', branch: 'rails-4-x'

group :development do
  # Performance
  gem 'activerecord-cause' # tell caller_location
  gem 'bullet' # validate N+1 query
  gem 'stackprof' # call-stack profiler
  gem 'spring' # preload application

  # Debug
  gem 'web-console', '~> 2.0'
  gem 'better_errors'
  gem 'byebug'

  # Data
  gem 'yaml_db'

  # Static analysis
  gem 'rubocop', require: false
  gem 'rails_best_practices'

  # Deploy
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-faster-assets'
  gem 'capistrano3-unicorn'
end

# Server
group :test, :production do
  gem 'therubyracer', platforms: :ruby
  gem 'unicorn'
end
