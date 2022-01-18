module Consul
  class Application < Rails::Application
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    logger = ActiveSupport::TaggedLogging.new(logger)

    config.logger = logger
    config.assets.initialize_on_precompile = false

    config.x.theme.current = ENV["THEME"]
    config.x.theme.load_path = Rails.root.join(
      "app",
      "assets",
      "stylesheets",
      "themes"
    )

    config.after_initialize do
      Delayed::Worker.logger = logger
    end
  end
end
