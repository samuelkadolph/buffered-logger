require "test_helper"

describe "BufferedLogger slow tests" do
  before do
    @buffer = StringIO.new
    @logger = BufferedLogger.new(@buffer)
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
