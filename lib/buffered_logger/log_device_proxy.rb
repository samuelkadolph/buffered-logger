require "thread"

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
      @logdev.write(@buffers.delete(key).string)
    end

    def flush
      log, @buffers[key] = @buffers.delete(key).string, StringIO.new
      @logdev.write(log)
    end

    def start
      @buffers[key] = StringIO.new
    end

    def started?
      @buffers.clone.key?(key)
    end

    def sweep
      @buffers.clone.each do |key, buffer|
        @buffers.delete(key) unless key.all?(&:alive?)
      end
      true
    end

    def write(message)
      if started?
        @buffers[key].write(message)
      else
        @logdev.write(message)
      end
    end

    def current_log
      @buffers[key].string.dup
    end

    private
      def key
        [Thread.current]
      end
  end
end
