# frozen_string_literal: true

# TasksController handles CRUD operations for Task resources
# Following Clean Code principles with clear method names and single responsibility
class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy toggle]

  # GET /tasks or /tasks.json
  # Retrieves all tasks ordered by creation date (newest first)
  def index
    @tasks = Task.order(created_at: :desc)
  end

  # GET /tasks/:id
  def show; end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/:id/edit
  def edit; end

  # POST /tasks or /tasks.json
  # Creates a new task with the provided parameters
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: "Task was successfully created!" }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/:id or /tasks/:id.json
  # Updates an existing task
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: "Task was successfully updated!" }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/:id or /tasks/:id.json
  # Destroys the specified task
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task was successfully destroyed!" }
      format.json { head :no_content }
    end
  end

  # PATCH /tasks/:id/toggle
  # Toggles the completion status of a task (for AJAX calls)
  def toggle
    @task.completed = !@task.completed

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: "Task status updated!" }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { redirect_to tasks_path, alert: "Failed to update task status." }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through
  def task_params
    params.require(:task).permit(:title, :description, :completed)
  end
end
