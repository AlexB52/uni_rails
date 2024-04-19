# Pick the frameworks you want:

require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie" unless ENV['DATABASE_URL'].nil?
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
# require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"
require "action_view/testing/resolvers"

module UniRails
  class App < Rails::Application
    config.load_defaults 7.1

    config.eager_load = true
    config.logger = Logger.new(STDOUT)
    config.log_level = :debug

    config.after_initialize do
      ActionController::Base.view_paths = Views.view_paths
      ActionController::Base.include App.routes.url_helpers
      ActionController::Base.helper Helpers::JavascriptHelper
      ActionController::Base.helper Helpers::CSSHelper
    end
  end
end
