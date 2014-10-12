require 'logger'

class BufferedLogger < ::Logger
  require "buffered_logger/errors"
  require "buffered_logger/log_device_proxy"
  require "buffered_logger/middleware"
  require "buffered_logger/version"

  attr_accessor :sweep_frequency

  def initialize(*)
    super
    @logdev = LogDeviceProxy.new(@logdev)
    self.sweep_frequency = 0.02
  end

  def exception_handler=(handler)
    @logdev.exception_handler = handler
  end

  def end
    raise NotStartedError, "not started" unless started?
    @logdev.end
    sweep if rand <= sweep_frequency
    nil
  end

  def flush
    @logdev.flush
  end

  def start(&block)
    raise AlreadyStartedError, "already started" if started?
    @logdev.start

    if block_given?
      begin
        yield
      ensure
        self.end
      end
    else
      true
    end
  end

  def started?
    @logdev.started?
  end

  def sweep
    @logdev.sweep
  end

  def current_log
    @logdev.current_log
  end
end
