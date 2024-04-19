# Based on the Hotwire tutorial: https://www.colby.so/posts/turbo-rails-101-todo-list
# Run the application
#   $ ruby todos-hotwire.rb

ENV['SECRET_KEY_BASE'] = 'my_secret_key_base'
ENV['DATABASE_URL'] = "sqlite3:///#{Dir.pwd}/todos-hotwire.sqlite"

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'uni_rails'
  gem 'sqlite3', '~> 1.7'
  gem 'debug'
end

require 'uni_rails'
require 'sqlite3'

ActiveRecord::Base.establish_connection
ActiveRecord::Schema.define do
  create_table :todos, force: :cascade do |t|
    t.string :name
    t.integer :status, default: 0
    t.timestamps
  end
end

UniRails.enable_turbo_rails!

UniRails::App.routes.append do
  root 'todos#index'
  resources :todos do
    patch :change_status, on: :member
  end
end

# MODELS

class Todo < ActiveRecord::Base
  enum status: {
    incomplete: 0,
    complete: 1
  }

  validates :name, presence: true
end


# CONTROLLERS

class TodosController < ActionController::Base
  layout 'application'

  before_action :set_todo, only: [:edit, :update, :destroy, :change_status]

  def index
    @todos = Todo.where(status: params[:status].presence || 'incomplete')
  end

  def new
    @todo = Todo.new
  end

  def edit
    @todo = Todo.find(params[:id])
  end

  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.turbo_stream
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@todo)}_form", partial: "form", locals: { todo: @todo }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.turbo_stream
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@todo)}_form", partial: "form", locals: { todo: @todo }) }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@todo)}_container") }
      format.html { redirect_to todos_url, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def change_status
    @todo.update(status: todo_params[:status])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@todo)}_container") }
      format.html { redirect_to todos_path, notice: "Updated todo status." }
    end
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:name, :status)
  end
end

# VIEWS

UniRails.javascript <<~JAVASCRIPT
  import * as Turbo from "turbo"
JAVASCRIPT

UniRails.register_view "layouts/application.html.erb",  <<~'HTML'
  <!DOCTYPE html>
  <html>
    <head>
      <title>Template</title>
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>
      <script src="https://cdn.tailwindcss.com"></script>
      <%= uni_rails_css_stylesheet %>
      <%= uni_rails_import_map_tag %>
      <%= uni_rails_javascript_script %>
    </head>

    <body>
      <%= yield %>
    </body>
  </html>
HTML

UniRails.register_view "todos/index.html.erb", <<~'HTML'
  <div class="mx-auto w-1/2">
    <h2 class="text-2xl text-gray-900">
      Your todos
    </h2>
    <%= turbo_frame_tag "todos-container", class: "block max-w-2xl w-full bg-gray-100 py-8 px-4 border border-gray-200 rounded shadow-sm" do %>
      <div class="border-b border-gray-200 w-full">
        <ul class="flex space-x-2 justify-center">
          <li>
            <%= link_to "Incomplete",
              todos_path(status: "incomplete"),
              class: "inline-block py-4 px-4 text-sm font-medium text-center text-gray-500 border-b-2 border-transparent hover:text-gray-600 hover:border-gray-300"
            %>
          <li>
            <%= link_to "Complete",
              todos_path(status: "complete"),
              class: "inline-block py-4 px-4 text-sm font-medium text-center text-gray-500 border-b-2 border-transparent hover:text-gray-600 hover:border-gray-300"
            %>
          </li>
      </ul>
      </div>
      <% unless params[:status] == "complete" %>
        <div class="py-2 px-4">
          <%= render "form", todo: Todo.new %>
        </div>
      <% end %>
      <ul id="todos">
        <%= render @todos %>
      </ul>
    <% end %>
  </div>
HTML

UniRails.register_view "todos/_form.html.erb", <<~'HTML'
  <%= form_with(model: todo, id: "#{dom_id(todo)}_form") do |form| %>
    <% if todo.errors.any? %>
      <div id="error_explanation" class="bg-red-50 text-red-500 px-3 py-2 font-medium rounded-lg mt-3">
        <h2><%= pluralize(todo.errors.count, "error") %> prohibited this todo from being saved:</h2>

        <ul>
          <% todo.errors.each do |error| %>
            <li><%= error.full_message %></li>
          <% end %>
        </ul>
      </div>
    <% end %>
    <div class="flex items-stretch flex-grow">
      <%= form.label :name, class: "sr-only" %>
      <%= form.text_field :name, class: "block w-full rounded-none rounded-l-md sm:text-sm border-gray-300", placeholder: "Add a new todo..." %>
      <%= form.submit class: "-ml-px relative px-4 py-2 border border-blue-600 text-sm font-medium rounded-r-md text-white bg-blue-600 hover:bg-blue-700" %>
    </div>
  <% end %>
HTML

UniRails.register_view "todos/_todo.html.erb", <<~'HTML'
  <li id="<%= "#{dom_id(todo)}_container" %>" class="py-2 px-4 border-b border-gray-300">
    <%= turbo_frame_tag dom_id(todo) do %>
      <div class="flex justify-between items-center space-x-2">
        <%= link_to todo.name, edit_todo_path(todo), class: todo.complete? ? 'line-through' : '' %>

        <div class="flex justify-end space-x-3">
          <% if todo.complete? %>
            <%= button_to change_status_todo_path(todo, todo: { status: 'incomplete' }), class: "bg-green-600 px-4 py-2 rounded hover:bg-green-700", method: :patch do %>
              <span class="sr-only">Mark as incomplete</span>
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-white" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
            <% end %>
          <% else %>
            <%= button_to change_status_todo_path(todo, todo: { status: 'complete' }), class: "bg-gray-400 px-4 py-2 rounded hover:bg-green-700", method: :patch do %>
              <span class="sr-only">Mark as complete</span>
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-white" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
            <% end %>
          <% end %>

          <%= button_to todo_path(todo), class: "bg-red-600 px-4 py-2 rounded hover:bg-red-700", method: :delete do %>
            <span class="sr-only">Delete</span>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-white" viewBox="0 0 20 20" fill="currentColor" title="Delete todo">
              <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
            </svg>
          <% end %>
        </div>
      </div>
    <% end %>
  </li>
HTML

UniRails.register_view "todos/edit.html.erb", <<~'HTML'
  <%= turbo_frame_tag dom_id(@todo) do %>
    <%= render "form", todo: @todo %>
  <% end %>
HTML

UniRails.register_view "todos/create.turbo_stream.erb", <<~'HTML'
  <%= turbo_stream.prepend "todos" do %>
    <%= render "todo", todo: @todo %>
  <% end %>
  <%= turbo_stream.replace "#{dom_id(Todo.new)}_form" do %>
    <%= render "form", todo: Todo.new %>
  <% end %>
HTML

UniRails.register_view "todos/update.turbo_stream.erb", <<~'HTML'
  <%= turbo_stream.replace "#{dom_id(@todo)}_container" do %>
    <%= render "todo", todo: @todo %>
  <% end %>
HTML

UniRails.run(Port: 3000)
