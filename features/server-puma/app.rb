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

UniRails::App.configure do
  config.log_level = :error
  config.hosts << ENV['APP_HOST']
end

UniRails.run(Port: 3000, BindAddress: '0.0.0.0')
