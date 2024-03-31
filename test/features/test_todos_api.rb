require "test_helper"

OUTER_APP ||= begin # APP setup
  app_path = "test/features/fixtures/apps/todos_api.rb"
  system "ruby", app_path, "db_setup"
  build_rackup_app(app_path)
end

class TestTodosApi < Minitest::Test
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_get_index
    get "/todos"
    assert last_response.ok?
  end

  def test_full_crud_workflow
    # LIST TODOS
    todos = get_todos
    assert_equal 0, todos.length

    # CREATE A TODO
    post "/todos", { todo: { name: "a new todo" } }
    assert last_response.created?

    todos = get_todos
    assert_equal 1, todos.length

    todo = todos.first
    assert_equal "a new todo", todo.name
    assert_nil todo.completed_at

    # UPDATE A TODO
    put "/todos/#{todo.id}", { todo: { name: 'updated name' } }
    todo = get_todos.first

    assert_equal "updated name", todo.name
    assert_nil todo.completed_at

    # COMPLETE A TODO
    put "/todos/#{todo.id}/complete"
    assert get_todos.first.completed_at

    # DELETE A TODO
    delete "/todos/#{todo.id}"

    todos = get_todos
    assert_equal 0, todos.length
  end

  private

  def get_todos
    get "/todos"
    JSON.parse(last_response.body).map { |todo| Todo.new(todo) }
  end
end
