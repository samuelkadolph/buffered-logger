require "test_helper"

describe BufferedLogger::LogDeviceProxy do
  before do
    @logdev = mock()
    @proxy = BufferedLogger::LogDeviceProxy.new(@logdev)
  end

  it "should call write" do
    @logdev.expects(:write)
    @proxy.write("message")
  end

  it "should call close on the logdev when close is called" do
    @logdev.expects(:close)
    @proxy.close
  end

  it "should not call write on the logdev once started" do
    @logdev.expects(:write).never
    @proxy.start
    @proxy.write("message")
  end

  it "should be started? once started" do
    @proxy.start
    assert @proxy.started?
  end

  it "should call write once started and ended" do
    @logdev.expects(:write)
    @proxy.start
    @proxy.write("message")
    @proxy.end
  end

  it "should buffer all writes and write them once" do
    @logdev.expects(:write).with("123")
    @proxy.start
    @proxy.write("1")
    @proxy.write("2")
    @proxy.write("3")
    @proxy.end
  end

  it "should flush the buffered log and then start buffering again" do
    @logdev.expects(:write).with("12")
    @proxy.start
    @proxy.write("1")
    @proxy.write("2")
    @proxy.flush
    @proxy.write("3")
  end

  it "should allow access to the current buffer in string form" do
    @proxy.start
    @proxy.write("1")
    @proxy.write("2")
    assert_equal "12", @proxy.current_log
  end

  describe "flush" do
    it "should handle multiple thread simutaneously calling it" do
      @logdev.stubs(:write)

      8.times do |iteration|
        threads = []
        8.times do
          threads << Thread.new do
            (iteration * 10_000).times do
              @proxy.start
              @proxy.flush
              @proxy.end
            end
          end
        end
        threads.each { |thr| thr.join }
      end
    end
  end
end
