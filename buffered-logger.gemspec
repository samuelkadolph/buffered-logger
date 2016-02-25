require File.expand_path("../.gemspec", __FILE__)
require File.expand_path("../lib/buffered_logger/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "buffered-logger"
  gem.authors     = ["Samuel Kadolph"]
  gem.email       = ["samuel@kadolph.com"]
  gem.description = readme.description
  gem.summary     = readme.summary
  gem.homepage    = "http://samuelkadolph.github.com/buffered-logger/"
  gem.version     = BufferedLogger::VERSION

  gem.files       = Dir["lib/**/*"]
  gem.test_files  = Dir["test/**/*_test.rb"]

  gem.required_ruby_version = ">= 2.0.0"

  gem.add_development_dependency "mocha", "~> 0.13.3"
  gem.add_development_dependency "rake", "~> 10.0.4"
end
