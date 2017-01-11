require "test_helper"

module Sidekiq; end

describe BufferedLogger::SidekiqMiddleware do
  before do
    @logger = mock()
    @logger.stubs(:start).yields()
    Sidekiq.stubs(:logger).returns(@logger)
    @middleware = BufferedLogger::SidekiqMiddleware.new
  end

  it "should call start" do
    @logger.expects(:start).yields()
    @middleware.call(nil) {}
  end

  it "yields the arguments" do
    result = "result"
    called = false
    @middleware.call("1", "2") do |a, b|
      called = true
      assert_equal "1", a
      assert_equal "2", b
    end
    assert called
  end
end
