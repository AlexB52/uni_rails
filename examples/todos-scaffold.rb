
ENV['SECRET_KEY_BASE'] = 'my_secret_key_base'
ENV['DATABASE_URL'] = "sqlite3:///#{Dir.pwd}/todos-scaffold.sqlite"

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'uni_rails'
  gem 'sqlite3', '~> 1.7'
  gem 'jbuilder' # jbuilder allows the .jbuilder extension for views
end

require 'uni_rails'
require 'sqlite3'

ActiveRecord::Base.establish_connection
ActiveRecord::Schema.define do
  create_table :todos, force: :cascade do |t|
    t.string :name
    t.datetime :completed_at
    t.timestamps
  end
end

UniRails.routes do
  root 'todos#index'
  resources :todos
end

# MODELS

class Todo < ActiveRecord::Base
  validates :name, presence: true

  def complete(at: Time.zone.now)
    update(completed_at: at)
  end
end


# CONTROLLERS
class ApplicationController < ActionController::Base
end

class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy!

    respond_to do |format|
      format.html { redirect_to todos_url, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:name, :completed_at)
    end
end

# VIEWS - HTML

UniRails.register_view "todos/_form.html.erb", <<~HTML
  <%= form_with(model: todo) do |form| %>
    <% if todo.errors.any? %>
      <div style="color: red">
        <h2><%= pluralize(todo.errors.count, "error") %> prohibited this todo from being saved:</h2>

        <ul>
          <% todo.errors.each do |error| %>
            <li><%= error.full_message %></li>
          <% end %>
        </ul>
      </div>
    <% end %>

    <div>
      <%= form.label :name, style: "display: block" %>
      <%= form.text_field :name %>
    </div>

    <div>
      <%= form.label :completed_at, style: "display: block" %>
      <%= form.datetime_field :completed_at %>
    </div>

    <div>
      <%= form.submit %>
    </div>
  <% end %>
HTML

UniRails.register_view "todos/_todo.html.erb", <<~HTML
  <div id="<%= dom_id todo %>">
    <p>
      <strong>Name:</strong>
      <%= todo.name %>
    </p>

    <p>
      <strong>Completed at:</strong>
      <%= todo.completed_at %>
    </p>

  </div>
HTML

UniRails.register_view "todos/edit.html.erb", <<~HTML
  <h1>Editing todo</h1>

  <%= render "form", todo: @todo %>

  <br>

  <div>
    <%= link_to "Show this todo", @todo %> |
    <%= link_to "Back to todos", todos_path %>
  </div>
HTML

UniRails.register_view "todos/index.html.erb", <<~HTML
  <p style="color: green"><%= notice %></p>

  <h1>Todos</h1>

  <div id="todos">
    <% @todos.each do |todo| %>
      <%= render todo %>
      <p>
        <%= link_to "Show this todo", todo %>
      </p>
    <% end %>
  </div>

  <%= link_to "New todo", new_todo_path %>
HTML

UniRails.register_view "todos/new.html.erb", <<~HTML
  <h1>New todo</h1>

  <%= render "form", todo: @todo %>

  <br>

  <div>
    <%= link_to "Back to todos", todos_path %>
  </div>
HTML

UniRails.register_view "todos/show.html.erb", <<~HTML
  <p style="color: green"><%= notice %></p>

  <%= render @todo %>

  <div>
    <%= link_to "Edit this todo", edit_todo_path(@todo) %> |
    <%= link_to "Back to todos", todos_path %>

    <%= button_to "Destroy this todo", @todo, method: :delete %>
  </div>
HTML

# VIEWS - JSON

UniRails.register_view "todos/_todo.json.jbuilder", <<~RUBY
  json.extract! todo, :id, :name, :completed_at, :created_at, :updated_at
  json.url todo_url(todo, format: :json)
RUBY

UniRails.register_view "todos/index.json.jbuilder", <<~RUBY
  json.array! @todos, partial: "todos/todo", as: :todo
RUBY

UniRails.register_view "todos/show.json.jbuilder", <<~RUBY
  json.partial! "todos/todo", todo: @todo
RUBY

UniRails.run(Port: 3000)
