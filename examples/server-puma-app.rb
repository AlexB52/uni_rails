
ENV['SECRET_KEY_BASE'] = 'my_secret_key_base'

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'uni_rails', '~> 0.5.0'
  gem 'puma'
end

require 'uni_rails'
require 'rack/handler/puma'

UniRails.rackup_handler = Rack::Handler::Puma

UniRails.routes do
  root 'pages#index'
end

class PagesController < ActionController::Base
  def index
    render plain: 'Application served by Puma'
  end
end

UniRails.run(Port: 3000)
