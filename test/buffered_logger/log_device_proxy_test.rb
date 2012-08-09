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
end
