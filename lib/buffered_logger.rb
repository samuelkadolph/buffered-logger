require "logger"

class BufferedLogger < Logger
  require "buffered_logger/errors"
  require "buffered_logger/log_device_proxy"
  require "buffered_logger/middleware"
  require "buffered_logger/version"

  def initialize(*)
    super
    @logdev = LogDeviceProxy.new(@logdev)
  end

  def end
    raise NotStartedError, "not started" unless started?
    @logdev.end
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
end
