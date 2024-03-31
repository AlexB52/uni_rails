# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "uni_rails"

require "minitest/autorun"
require "rack/test"
require "debug"

def build_rackup_app(path)
  app = Rack::Builder.parse_file File.join(Dir.pwd, path)
  app.configure do
    config.hosts = ['example.org']
    config.log_level = :error
  end
  app.initialize!
  app
end
