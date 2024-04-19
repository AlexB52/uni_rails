# frozen_string_literal: true

if ENV['SECRET_KEY_BASE'].nil?
  raise StandardError, <<~ERROR

    SECRET_KEY_BASE environment variable is required
    Provide ENV['SECRET_KEY_BASE'] in your file or export the variable to your profile
  ERROR
end

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

  def self.enable_turbo_rails!
    # # We currently do not support ActionCable and ActiveJob
    require "turbo-rails"

    App.configure do
      initializer "turbo.no_action_cable", before: :set_eager_load_paths do
        unless defined?(ActionCable)
          Rails.autoloaders.once.do_not_eager_load("#{Turbo::Engine.root}/app/channels")
        end

        unless defined?(ActiveJob)
          Rails.autoloaders.once.do_not_eager_load("#{Turbo::Engine.root}/app/jobs")
        end
      end
    end

    UniRails::App::Javascript.dependencies = {
      "turbo" => "https://unpkg.com/@hotwired/turbo@8.0.4/dist/turbo.es2017-umd.js"
    }
  end

  def self.rackup_handler=(handler)
    @@rackup_handler = handler
  end

  def self.rackup_handler
    @@rackup_handler ||= begin
      require 'rackup'
      Rackup::Handler::WEBrick
    end
  end

  def self.register_view(action, view)
    UniRails::App::Views.instance.views[action] = view
  end

  def self.run(**webrick_options)
    App.initialize!
    rackup_handler.run App, **webrick_options
    # Rackup::Handler::Falcon.run App, **webrick_options
    # Rack::Handler::Puma.run App, **webrick_options
    # Rackup::Handler::WEBrick.run App, **webrick_options
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
