class BufferedLogger::SidekiqMiddleware
  def call(*args)
    Sidekiq.logger.start { yield *args }
  end
end
