require "test_helper"

class MockLogDeviceProxy
  def initialize
    @started = false
  end

  def end
    @started = false
  end

  def start
    @started = true

    if block_given?
      begin
        yield
      ensure
        @started = false
      end
    else
      true
    end
  end

  def started?
    @started
  end
end

describe BufferedLogger do
  describe "with MockLogDeviceProxy" do
    def setup
      @logdev = MockLogDeviceProxy.new
      @logger = BufferedLogger.allocate
      @logger.instance_variable_set(:@logdev, @logdev)
    end

    it "should raise an error if end is called while not started" do
      -> { @logger.end }.must_raise(BufferedLogger::NotStartedError)
    end

    it "should raise an error if start is called while already started" do
      @logger.start
      -> { @logger.start }.must_raise(BufferedLogger::AlreadyStartedError)
    end
  end

  describe "with mock" do
    def setup
      @logdev = mock()
      @logger = BufferedLogger.allocate
      @logger.instance_variable_set(:@logdev, @logdev)
    end

    it "should call end on logdev" do
      @logdev.expects(:end)
      @logdev.stubs(:started?).returns(true)
      @logger.end
    end

    it "should call start on logdev" do
      @logdev.expects(:start)
      @logdev.stubs(:started?).returns(false)
      @logger.start
    end

    it "should call started? on logdev" do
      @logdev.expects(:started?)
      @logger.started?
    end
  end
end
