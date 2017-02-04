require File.expand_path('../boot', __FILE__)

require 'rails/all'

# https://github.com/zdennis/activerecord-import/issues/149
require 'activerecord-import/base'
# override
class ActiveRecord::Base
  class << self
    alias bulk_import import
    remove_method :import
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# module
module My100tales
  # class
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # locales
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:en, :ja]
    config.i18n.default_locale = :en

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # performance
    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework :rspec, view_specs: false, routing_specs: false
    end
  end
end
