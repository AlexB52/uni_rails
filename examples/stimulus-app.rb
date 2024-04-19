# Run the application
#   $ ruby hello-world.rb

ENV['SECRET_KEY_BASE'] = 'my_secret_key_base'

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  gem 'uni_rails'
end

require 'uni_rails'

UniRails::App.routes.append do
  root 'pages#index'
end

UniRails.import_maps(
  'stimulus' => 'https://unpkg.com/@hotwired/stimulus/dist/stimulus.js'
)

UniRails.javascript <<~JAVASCRIPT
  import { Application, Controller } from "stimulus"
  window.Stimulus = Application.start()

  Stimulus.register("hello", class extends Controller {
    connect() {
      console.log("hello world")
    }
  })
JAVASCRIPT

class PagesController < ActionController::Base
  layout 'application'
  def index;end
end

UniRails.register_view "pages/index.html.erb", <<~HTML
  <div data-controller="hello">Check out the dev console to see "hello world"</div>
HTML

UniRails.run(Port: 3000)
