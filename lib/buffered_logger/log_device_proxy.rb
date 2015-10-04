require "thread"

class BufferedLogger
  class LogDeviceProxy
    THREAD_LOCAL_VAR_NAME = :"BufferedLogger::LogDeviceProxy::string_io"

    def initialize(logdev)
      @logdev = logdev
      destroy_thread_local
    end

    def close
      @logdev.close
    end

    def end
      @logdev.write(string_io.string)
      destroy_thread_local
    end

    def flush
      @logdev.write(string_io.string)
      string_io.string.clear
    end

    def start
      Thread.current.thread_variable_set(THREAD_LOCAL_VAR_NAME,StringIO.new)
    end

    def started?
      !!string_io
    end

    def write(message)
      if started?
        string_io.write(message)
      else
        @logdev.write(message)
      end
    end

    def current_log
      string_io.string.dup
    end

    private
    def string_io
      Thread.current.thread_variable_get(THREAD_LOCAL_VAR_NAME)
    end

    def destroy_thread_local
      Thread.current.thread_variable_set(THREAD_LOCAL_VAR_NAME,nil)
    end
  end
end
