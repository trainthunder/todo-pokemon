# filepath: test/controllers/tasks_controller_test.rb
require "test_helper"

# TasksController Test - Following BDD principles
# Tests the behavior of the TasksController
class TasksControllerTest < ActionDispatch::IntegrationTest
  # ============================================
  # Setup - Clear tasks before each test
  # ============================================
  setup do
    Task.destroy_all
  end

  # ============================================
  # Index Action Tests
  # ============================================

  test "should get index" do
    get tasks_url
    assert_response :success
    assert_select "h1", /Pokemon Todo List/
  end

  test "should display all tasks" do
    Task.create!(title: "Task 1", completed: false)
    Task.create!(title: "Task 2", completed: true)

    get tasks_url
    assert_response :success
    assert_select ".task-card", minimum: 2
  end

  test "should display empty state when no tasks" do
    Task.destroy_all

    get tasks_url
    assert_response :success
    assert_select ".empty-state"
  end

  test "should display task statistics" do
    Task.create!(title: "Completed Task", completed: true)
    Task.create!(title: "Pending Task", completed: false)

    get tasks_url
    assert_response :success
    assert_select ".stat.completed", /Completed:/
    assert_select ".stat.pending", /Pending:/
  end

  # ============================================
  # New Action Tests
  # ============================================

  test "should get new" do
    get new_task_url
    assert_response :success
    assert_select "h2", /Create New Task/
  end

  # ============================================
  # Create Action Tests
  # ============================================

  test "should create task with valid data" do
    assert_difference("Task.count", 1) do
      post tasks_url, params: { task: { title: "New Task", description: "Test description" } }
    end

    assert_redirected_to tasks_path
  end

  test "should not create task with invalid data" do
    assert_no_difference("Task.count") do
      post tasks_url, params: { task: { title: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "should create task and redirect to index" do
    post tasks_url, params: { task: { title: "Catch 'em all" } }
    assert_redirected_to tasks_path
  end

  # ============================================
  # Edit Action Tests
  # ============================================

  test "should get edit" do
    task = Task.create!(title: "Test Task")
    get edit_task_url(task)
    assert_response :success
    assert_select "h2", /Edit Task/
  end

  # ============================================
  # Update Action Tests
  # ============================================

  test "should update task with valid data" do
    task = Task.create!(title: "Original Title")

    patch task_url(task), params: { task: { title: "Updated Title" } }
    assert_redirected_to tasks_path
    assert_equal "Updated Title", task.reload.title
  end

  test "should not update task with invalid data" do
    task = Task.create!(title: "Test Task")

    patch task_url(task), params: { task: { title: "" } }
    assert_response :unprocessable_entity
  end

  # ============================================
  # Toggle Action Tests
  # ============================================

  test "should toggle task completion status" do
    task = Task.create!(title: "Test Task", completed: false)

    patch toggle_task_url(task)
    assert_redirected_to tasks_path
    assert task.reload.completed
  end

  test "should toggle back to incomplete" do
    task = Task.create!(title: "Test Task", completed: true)

    patch toggle_task_url(task)
    assert_redirected_to tasks_path
    assert_not task.reload.completed
  end

  # ============================================
  # Destroy Action Tests
  # ============================================

  test "should destroy task" do
    task = Task.create!(title: "Task to delete")

    assert_difference("Task.count", -1) do
      delete task_url(task)
    end

    assert_redirected_to tasks_path
  end

  # ============================================
  # Edge Cases & Error Handling
  # ============================================

  test "should handle non-existent task" do
    # Rails 7 returns 404 for non-existent records
    get edit_task_url(99999)
    assert_response :not_found
  end

  test "should handle update with empty title" do
    task = Task.create!(title: "Test Task")

    patch task_url(task), params: { task: { title: "" } }
    assert_response :unprocessable_entity
  end
end
