class BufferedLogger
  class LogDeviceProxy
    def initialize(logdev)
      @logdev = logdev
      @buffers = {}
    end

    def close
      @logdev.close
    end

    def end
      @logdev.write(@buffers.delete(Thread.current).string)
    end

    def start
      @buffers[Thread.current] = StringIO.new
    end

    def started?
      @buffers.key?(Thread.current)
    end

    def write(message)
      if started?
        @buffers[Thread.current].write(message)
      else
        @logdev.write(message)
      end
    end
  end
end
