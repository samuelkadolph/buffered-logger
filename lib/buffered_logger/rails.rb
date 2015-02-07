require "buffered_logger"
require "rails"

class BufferedLogger
  class Railtie < Rails::Railtie
    config.buffered_logger = Struct.new(:output_stream).new

    initializer :buffered_logger, :before => :initialize_logger do |app|
      next if app.config.logger

      output_stream = app.config.buffered_logger.output_stream || default_output_stream(app)

      output_stream.binmode
      output_stream.sync = true

      logger = BufferedLogger.new(output_stream)
      logger.formatter = app.config.log_formatter
      if defined?(ActiveSupport::TaggedLogging)
        logger = ActiveSupport::TaggedLogging.new(logger)
      end
      logger.level = BufferedLogger.const_get(app.config.log_level.to_s.upcase)
      app.config.logger = logger
      app.config.middleware.insert(0, BufferedLogger::Middleware, app.config.logger)
    end

    def default_output_stream(app)
      if Rails::VERSION::STRING >= "3.1"
        path = app.paths["log"].first
      else
        path = app.paths.log.to_a.first
      end

      File.open(path, "a")
    end
  end
end
