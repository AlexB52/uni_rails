require "capybara"
require "capybara/dsl"
require 'capybara/minitest'
require "selenium-webdriver"
require "minitest/autorun"
require "debug"

Capybara.register_driver :selenium_remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  # Add any additional options you need
  # options.add_argument('--headless') # Uncomment if you want to run headless mode

  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: "http://selenium:4444/wd/hub",
    options: options
  )
end

Capybara.default_driver = :selenium_remote_chrome
Capybara.app_host = "http://uni_rails:3000"

class TestNewTodos < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  def test_create_a_new_todo
    visit "/"

    click_on 'New todo'
    assert_text 'New todo'

    fill_in 'Name', with: 'Buy milk'
    click_on 'Create'

    assert_text 'Todo was successfully created.'
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

