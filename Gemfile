source 'https://rubygems.org'

# Base
ruby '2.3.0'
gem 'rails', '4.2.7.1'
gem 'sdoc', '~> 0.4.0', group: :doc # TODO: document

# ENV
gem 'dotenv-rails'

# M/W
gem 'mysql2'
gem 'redis-rails'
gem 'elasticsearch-rails', '0.1.9'
gem 'elasticsearch-model', '0.1.9'

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
gem 'sassc-rails' # gem 'sass-rails', '~> 5.0'
gem 'honoka-rails', '~> 3.3.6.0' # gem 'bootstrap-sass'

# JavaScript
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '4.1.1'
gem 'vuejs-rails', '1.0.21'
gem 'bower-rails'

# View Performance
gem 'turbolinks', '~> 2.5.0'

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

  # Mail
  gem 'letter_opener'

  # Static analysis
  gem 'rubocop', require: false
  gem 'rails_best_practices', require: false

  # Security
  gem 'brakeman', require: false

  # Deploy
  gem 'capistrano', '~> 3.7.0'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
end

# Server
group :test, :production do
  gem 'therubyracer', platforms: :ruby
  gem 'unicorn'
end
