require "test_helper"

describe "BufferedLogger::LogDeviceProxy slow tests" do
  before do
    @logdev = mock()
    @proxy = BufferedLogger::LogDeviceProxy.new(@logdev)
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
