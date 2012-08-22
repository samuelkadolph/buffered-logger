require "test_helper"

describe BufferedLogger::LogDeviceProxy do
  def setup
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

  describe "sweep" do
    it "should check if the thread and fiber are alive" do
      fiber = mock()
      fiber.expects(:alive?).returns(true)
      thread = mock()
      thread.expects(:alive?).returns(true)
      Fiber.stubs(:current).returns(fiber)
      Thread.stubs(:current).returns(thread)

      @proxy.start
      @proxy.sweep
    end

    it "should remove dead threads or fibers" do
      fiber = mock()
      fiber.stubs(:alive?).returns(false)
      thread = mock()
      thread.stubs(:alive?).returns(true)
      Fiber.stubs(:current).returns(fiber)
      Thread.stubs(:current).returns(thread)

      @proxy.start
      @proxy.sweep
      assert !@proxy.started?

      fiber.stubs(:alive?).returns(true)
      thread.stubs(:alive?).returns(false)

      @proxy.start
      @proxy.sweep
      assert !@proxy.started?
    end
  end
end
