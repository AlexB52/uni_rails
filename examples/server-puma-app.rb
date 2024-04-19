# Run the application
#   $ ruby server-puma-app.rb

ENV['SECRET_KEY_BASE'] = 'my_secret_key_base'

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'uni_rails', path: '/Users/alex/projects/uni_rails'
  gem 'puma'
end

require 'uni_rails'
require 'rack/handler/puma'

UniRails.rackup_handler = Rack::Handler::Puma

UniRails::App.routes.append do
  root 'pages#index'
end

class PagesController < ActionController::Base
  def index
    render plain: 'Application served by Puma'
  end
end

UniRails.run(Port: 3000)
