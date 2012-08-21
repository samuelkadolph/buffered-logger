require "test_helper"

describe BufferedLogger do
  describe "with MockLogDeviceProxy" do
    def setup
      @buffer = StringIO.new
      @logger = BufferedLogger.new(@buffer)
    end

    it "should raise an error if end is called while not started" do
      @logger.stubs(:started?).returns(false)
      -> { @logger.end }.must_raise(BufferedLogger::NotStartedError)
    end

    it "should raise an error if start is called while already started" do
      @logger.stubs(:started?).returns(true)
      -> { @logger.start }.must_raise(BufferedLogger::AlreadyStartedError)
    end
  end
end
