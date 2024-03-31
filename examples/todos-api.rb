# 1. Initialize the database with
#     $ ruby todos-api.rb db_setup

# 2. Run the application
#     $ ruby todos-api.rb

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'uni_rails'#, path: '/Users/alexbarret/projects/uni_rails'
  gem 'puma'
  gem 'debug'
  gem 'sqlite3'
end

require 'uni_rails'
require "rack/handler/puma"
require 'debug'
require 'sqlite3'

ENV['DATABASE_URL'] = "sqlite3:///#{Dir.pwd}/todos-api.sqlite"

if ARGV[0] == 'db_setup'
  ActiveRecord::Base.establish_connection
  ActiveRecord::Schema.define do
    create_table :todos, force: :cascade do |t|
      t.string :name
      t.datetime :completed_at
      t.timestamps
    end
  end
  return
end

UniRails::App.routes.append do
  resources :todos do
    put :complete, on: :member
  end
end

# MODELS

class Todo < ActiveRecord::Base
  validates :name, presence: true

  def complete(at: Time.zone.now)
    update(completed_at: at)
  end
end

# CONTROLLERS

class TodosController < ActionController::Base
  before_action :set_todo, only: [:show, :update, :destroy, :complete]

  def index
    @todos = Todo.all
    render json: @todos
  end

  def show
    render json: @todo
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def complete
    if @todo.complete
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:name, :status)
  end
end

UniRails.run(Port: 3000)
