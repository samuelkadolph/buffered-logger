require "thread"

class BufferedLogger
  class LogDeviceProxy
    def initialize(logdev)
      @logdev = logdev
      @buffers = {}
      @mutex = Mutex.new
    end

    def close
      @logdev.close
    end

    def end
      content = @mutex.synchronize { @buffers.delete(key).string }
      @logdev.write(content)
    end

    def flush
      content = @mutex.synchronize { @buffers.delete(key).string }
      log, @buffers[key] = content, StringIO.new
      @logdev.write(log)
    end

    def start
      @mutex.synchronize do
        @buffers[key] = StringIO.new
      end
    end

    def started?
      @buffers.key?(key)
    end

    def sweep
      @mutex.synchronize do
        @buffers.keep_if do |key, buffer|
          key.all?(&:alive?)
        end
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
