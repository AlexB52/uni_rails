# Run the application
#   $ ruby todos-api.rb

ENV['DATABASE_URL'] = "sqlite3:///#{Dir.pwd}/todos-api.sqlite"

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'uni_rails'
  gem 'sqlite3'
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

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
end

class TodosController < ApplicationController
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
