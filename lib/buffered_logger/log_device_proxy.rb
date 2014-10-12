require "fiber"
require "thread"

class BufferedLogger
  class LogDeviceProxy
    attr_accessor :exception_handler

    def initialize(logdev)
      @logdev = logdev
      @buffers = {}
    end

    def close
      @logdev.close
    end

    def end
      write_to_logdev(@buffers.delete(key).string)
    end

    def flush
      log, @buffers[key] = @buffers.delete(key).string, StringIO.new
      write_to_logdev(log)
    end

    def start
      @buffers[key] = StringIO.new
    end

    def started?
      @buffers.key?(key)
    end

    def sweep
      @buffers.keep_if do |key, buffer|
        key.all?(&:alive?)
      end
      true
    end

    def write(message)
      if started?
        @buffers[key].write(message)
      else
        write_to_logdev(message)
      end
    end

    def current_log
      @buffers[key].string.dup
    end

    private

      def write_to_logdev(message)
        @logdev.write(message)
      rescue => e
        if exception_handler
          reraise = exception_handler.call(e)
        end

        raise if !exception_handler || reraise
      end

      def key
        [Thread.current]
      end
  end
end
