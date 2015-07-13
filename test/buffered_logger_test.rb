require "test_helper"

describe BufferedLogger do
  before do
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

  it "does not raise an error with multiple threads working on a BufferedLogger instance" do
    threads = []
    thread = Thread.new { @logger.start; @logger.end }
    10.times { threads << thread }
    threads.each(&:join)
  end

  if defined?(ActiveSupport)
    it "only logs the string" do
      if defined?(ActiveSupport::Logger::SimpleFormatter)
        @logger.formatter = ActiveSupport::Logger::SimpleFormatter.new
      end
      @logger.debug "foo"

      assert_equal "foo\n", @buffer.string
    end
  end
end
