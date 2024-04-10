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
    Net::HTTP.start(@uri.hostname, @uri.port) do |http|
      yield http.get(url)
    end
  end

  def post(url, params)
    Net::HTTP.start(@uri.hostname, @uri.port) do |http|
      http.post(url, params.to_json, "Content-Type" => "application/json")
    end
  end

  def delete(url)
    Net::HTTP.start(@uri.hostname, @uri.port) do |http|
      http.delete(url)
    end
  end
end

class TestJSONTodos < Minitest::Test
  def setup
    @client = Client.new(APP_HOST)
  end

  def test_create_a_new_todo
    @client.get('/todos.json') do |response|
      todos = JSON.parse(response.body)
      assert_equal 0, todos.length
    end

    response = @client.post '/todos.json', { todo: { name: 'Buy milk' } }
    todo = JSON.parse(response.body)

    @client.get('/todos.json') do |response|
      todos = JSON.parse(response.body)
      assert_equal 1, todos.length
    end

    @client.delete("/todos/#{todo['id']}.json")

    @client.get('/todos.json') do |response|
      todos = JSON.parse(response.body)
      assert_equal 0, todos.length
    end
  end
end
