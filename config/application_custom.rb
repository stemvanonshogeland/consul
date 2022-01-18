module Consul
  class Application < Rails::Application
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    logger = ActiveSupport::TaggedLogging.new(logger)

    config.logger = logger
    config.assets.initialize_on_precompile = false

    config.after_initialize do
      Delayed::Worker.logger = logger
    end
  end
end
