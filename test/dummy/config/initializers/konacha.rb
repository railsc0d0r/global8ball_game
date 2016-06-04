if defined?(Konacha)
  # Avoids tilt autoloading tilt/coffee in a 'non-thread-safe way'.
  require 'tilt/coffee'

  Konacha.configure do |config|
    config.spec_dir     = "spec/javascripts"
    config.spec_matcher = /_spec\./
    config.driver       = :selenium
  end

  # Disable paper trail for specs controller. Paper trail enables itself for
  # all controllers by default, causing the specs to error out when trying to get
  # the "current user".
  Konacha::SpecsController.class_eval do
    def paper_trail_enabled_for_controller
      false
    end
  end
end
