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

  describe "sweep" do
    it "should check if the thread is alive" do
      thread = mock()
      thread.expects(:alive?).returns(true)
      Thread.stubs(:current).returns(thread)

      @proxy.start
      @proxy.sweep
    end

    it "should remove dead threads or fibers" do
      thread = mock()
      thread.stubs(:alive?).returns(true)
      Thread.stubs(:current).returns(thread)

      @proxy.start
      @proxy.sweep
      assert @proxy.started?, "Proxy is not started"

      thread.stubs(:alive?).returns(false)

      @proxy.start
      @proxy.sweep
      assert !@proxy.started?, "Proxy is started"
    end
  end
end
