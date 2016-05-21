require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'i18n-js'


Bundler.require(*Rails.groups)
require "global8ball_game"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Tells backend to automatically export translations and i18n-js
    config.middleware.use I18n::JS::Middleware
    I18n.available_locales = [ :de, :en, :es, :fr, :hi, :ru, :zh ]

  end
end

