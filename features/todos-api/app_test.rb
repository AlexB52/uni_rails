require "capybara"
require "capybara/dsl"
require 'capybara/minitest'
require "selenium-webdriver"
require "minitest/autorun"
require "debug"

APP_HOST = ENV.fetch('APP_HOST')

class Client
  def initialize(url)
    @uri = URI(url)
  end

  def get(url)
    start do |http|
      http.get(url)
    end
  end

  def post(url, params)
    start do |http|
      http.post(url, params.to_json, "Content-Type" => "application/json")
    end
  end

  def delete(url)
    start do |http|
      http.delete(url)
    end
  end

  def start
    Net::HTTP.start(@uri.hostname, @uri.port) do |http|
      yield http
    end
  end
end

class TestJSONTodos < Minitest::Test
  def setup
    @client = Client.new(APP_HOST)
  end

  def test_create_a_new_todo
    response = @client.get('/todos.json')
    todos = JSON.parse(response.body)
    assert_equal 0, todos.length

    response = @client.post '/todos.json', { todo: { name: 'Buy milk' } }
    todo = JSON.parse(response.body)

    response = @client.get('/todos.json')
    todos = JSON.parse(response.body)
    assert_equal 1, todos.length

    @client.delete("/todos/#{todo['id']}.json")

    response = @client.get('/todos.json')
    todos = JSON.parse(response.body)
    assert_equal 0, todos.length
  end
end
