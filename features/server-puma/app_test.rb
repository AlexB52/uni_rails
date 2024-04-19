require "capybara"
require "capybara/dsl"
require 'capybara/minitest'
require "selenium-webdriver"
require "minitest/autorun"
require "debug"

APP_HOST = ENV.fetch('APP_HOST')

Capybara.register_driver :selenium_remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  # Add any additional options you need
  options.add_argument('--headless') # Uncomment if you want to run headless mode

  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: "http://selenium:4444/wd/hub",
    options: options
  )
end

Capybara.default_driver = :selenium_remote_chrome
Capybara.app_host = APP_HOST

class TestHTMLTodos < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def test_create_a_new_todo
    visit "/"
    assert_text 'Application served by Puma'
  end
end

