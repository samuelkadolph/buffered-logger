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

  if defined?(ActiveSupport)
    it "only logs the string" do
      if defined?(ActiveSupport::Logger::SimpleFormatter)
        @logger.formatter = ActiveSupport::Logger::SimpleFormatter.new
      end
      @logger.debug "foo"

      assert_equal "foo\n", @buffer.string
    end
  end

  it "should handle multiple thread simutaneously calling start with a block" do
    16.times do
      threads = []
      8.times do
        threads << Thread.new do
          32768.times do
            @logger.start {}
          end
        end
      end
      threads.each { |thr| thr.join }
      sleep(0.01 * rand)
    end
  end
end
