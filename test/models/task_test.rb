# filepath: test/models/task_test.rb
require "test_helper"

# Task Model Test - Following TDD principles
# Tests the core business logic of the Task model
class TaskTest < ActiveSupport::TestCase
  # ============================================
  # Unit Tests - Model Validation
  # ============================================

  test "should be valid with title" do
    task = Task.new(title: "Catch a Pikachu")
    assert task.valid?
  end

  test "title should be present" do
    task = Task.new
    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "title should not exceed 255 characters" do
    task = Task.new(title: "a" * 256)
    assert_not task.valid?
    assert_includes task.errors[:title], "is too long (maximum is 255 characters)"
  end

  test "description can be nil" do
    task = Task.new(title: "Test Task", description: nil)
    assert task.valid?
  end

  test "description should not exceed 1000 characters" do
    task = Task.new(title: "Test", description: "a" * 1001)
    assert_not task.valid?
    assert_includes task.errors[:description], "is too long (maximum is 1000 characters)"
  end

  # ============================================
  # Default Values Tests
  # ============================================

  test "completed should default to false" do
    task = Task.create!(title: "New Task")
    assert_not task.completed
  end

  # ============================================
  # CRUD Operations Tests
  # ============================================

  test "should save task with all attributes" do
    task = Task.new(
      title: "Defeat Brock",
      description: "Use Geodude to defeat Brock",
      completed: false
    )
    assert task.save
    assert_equal "Defeat Brock", task.title
    assert_equal "Use Geodude to defeat Brock", task.description
    assert_not task.completed
  end

  test "should update task" do
    task = Task.create!(title: "Original Title")
    assert task.update(title: "Updated Title")
    assert_equal "Updated Title", task.reload.title
  end

  test "should destroy task" do
    task = Task.create!(title: "Task to delete")
    task_id = task.id
    task.destroy
    assert_not Task.exists?(task_id)
  end

  # ============================================
  # Edge Cases
  # ============================================

  test "should handle empty title with whitespace" do
    task = Task.new(title: "   ")
    assert_not task.valid?
  end

  test "should strip title whitespace" do
    task = Task.new(title: "  Clean Title  ")
    task.save
    assert_equal "Clean Title", task.title
  end
end
