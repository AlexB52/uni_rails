# frozen_string_literal: true

ENV['SECRET_KEY_BASE'] = 'something'

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "uni_rails"

require "minitest/autorun"
require "debug"

