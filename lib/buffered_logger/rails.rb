require "buffered_logger"
require "rails"

class BufferedLogger
  class Railtie < Rails::Railtie
    initializer :buffered_logger, :before => :initialize_logger do |app|
      if Rails::VERSION::STRING >= "3.1"
        path = app.paths["log"].first
      else
        path = app.paths.log.to_a.first
      end

      file = File.open(path, "a")
      file.binmode
      file.sync = true

      app.config.logger = BufferedLogger.new(file)
      app.config.logger.level = BufferedLogger.const_get(app.config.log_level.to_s.upcase)
      app.config.middleware.insert(0, BufferedLogger::Middleware, app.config.logger)
    end
  end
end
