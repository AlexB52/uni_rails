
ENV['SECRET_KEY_BASE'] = 'my_secret_key_base'

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'uni_rails'
  gem 'falcon'
end

require 'uni_rails'
require 'rackup/handler/falcon'

UniRails.rackup_handler = Rackup::Handler::Falcon

UniRails.routes do
  root 'pages#index'
end

class PagesController < ActionController::Base
  def index
    render plain: 'Application served by Falcon'
  end
end

UniRails.run(Port: 3000)
