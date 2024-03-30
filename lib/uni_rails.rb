# frozen_string_literal: true

require "rails"
require_relative "uni_rails/version"
require_relative "uni_rails/helpers"
require_relative "uni_rails/helpers/css_helper"
require_relative "uni_rails/helpers/javascript_helper"
require_relative "uni_rails/app"
require_relative "uni_rails/app/css"
require_relative "uni_rails/app/javascript"
require_relative "uni_rails/app/views"

module UniRails
  class Error < StandardError; end

  def self.register_view(action, view)
    UniRails::App::Views.instance.views[action] = view
  end

  def self.run(**webrick_options)
    App.initialize!
    # Rackup::Handler::WEBrick.run App, **webrick_options
    # Rackup::Handler::Falcon.run App, **webrick_options
    Rack::Handler::Puma.run App, **webrick_options
  end

  def self.import_maps(dependencies)
    UniRails::App::Javascript.dependencies = dependencies
  end

  def self.javascript(content)
    UniRails::App::Javascript.javascript = content
  end

  def self.css(content)
    UniRails::App::CSS.css = content
  end
end
