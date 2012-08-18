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
end
