[![Build Status](https://secure.travis-ci.org/samuelkadolph/buffered-logger.png?branch=master)](http://travis-ci.org/samuelkadolph/buffered-logger)
[![Gem Version](https://badge.fury.io/rb/buffered-logger.png)](http://badge.fury.io/rb/buffered-logger)
[![Dependency Status](https://gemnasium.com/samuelkadolph/buffered-logger.png)](https://gemnasium.com/samuelkadolph/buffered-logger)
[![Code Climate](https://codeclimate.com/github/samuelkadolph/buffered-logger.png)](https://codeclimate.com/github/samuelkadolph/buffered-logger)

# buffered-logger

buffered-logger is a concurrency safe logger. It buffers each logging statement and writes to the log file all at once.

## Description

buffered-logger is designed to be used in multithreaded or multifiber rack servers and includes a middleware to
automatically capture and write the buffered log statements during each request. This is ideal for keeping requests together
for log parsing software such as [splunk](http://www.splunk.com/).

## Installation

If you're using rails, add this line your application's Gemfile:

```ruby
gem "buffered-logger", require: "buffered_logger/rails"
```

Otherwise add this line to your application's Gemfile:

```ruby
gem "buffered-logger"
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install buffered-logger
```

## Usage

```ruby
require "buffered_logger"

MyApp.logger = BufferedLogger.new("myapp.log")

use BufferedLogger::Middleware, MyApp.logger
run MyApp
```

If the `RAILS_LOG_TO_STDOUT` environment variable is set in a Rails environment, buffered-logger would be [12 factor app](https://12factor.net/logs) compatible for containerized environments.

## Contributing

Fork, branch & pull request.
