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


def truncate_tables
  require "sqlite3"
  SQLite3::Database.new( "database.sqlite" ) do |db|
    db.execute("DELETE FROM todos")
  end
end

class TestNewTodos < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  def setup
    truncate_tables
  end

  def test_create_a_new_todo
    visit "/"

    fill_in 'Name', with: 'Buy milk'
    click_on 'Create Todo'
    assert_text 'Buy milk'

    within first('ul#todos li') do
      click_on 'Buy milk'
      fill_in 'Name', with: 'Buy milk (updated)'
      click_on 'Update Todo'
    end

    assert_text 'Buy milk (updated)'
    click_on 'Mark as complete'

    assert_incomplete(0)
    assert_complete(1)

    click_on 'Complete'
    assert_text 'Buy milk (updated)'

    within first('ul#todos li') do
      click_on 'Mark as incomplete'
    end

    assert_incomplete(1)
    assert_complete(0)

    click_on 'Incomplete'
    assert_text 'Buy milk (updated)'

    within first('ul#todos li') do
      click_on 'Delete'
    end

    assert_complete(0)
    assert_incomplete(0)
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  private

  def assert_complete(n)
    click_on 'Complete'
    assert_equal n, all('ul#todos li').length
  end

  def assert_incomplete(n)
    click_on 'Incomplete'
    assert_equal n, all('ul#todos li').length
  end
end

