require "test_helper"

describe BufferedLogger::Middleware do
  def setup
    @app = mock()
    @app.stubs(:call).returns([200, {}, []])
    @logger = mock()
    def @logger.start; yield; end
    @middleware = BufferedLogger::Middleware.new(@app, @logger)
  end

  it "should call start" do
    @logger.expects(:start).yields()
    @middleware.call(nil)
  end

  it "behaves as a proper rack middleware" do
    result = [200, {}, []]
    env = mock()
    @app.expects(:call).with(env).returns(result)
    @middleware.call(env).must_equal(result)
  end
end
