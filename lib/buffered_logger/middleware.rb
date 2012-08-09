class BufferedLogger
  class Middleware
    def initialize(app, logger)
      @app, @logger = app, logger
    end

    def call(env)
      @logger.start { @app.call(env) }
    end
  end
end
