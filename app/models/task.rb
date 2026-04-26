# frozen_string_literal: true

# Task Model - Represents a todo item in the Pokemon Todo List
# Follows Clean Code principles with clear validations and scopes
class Task < ApplicationRecord
  # ============================================
  # Associations
  # ============================================

  # ============================================
  # Validations
  # ============================================
  validates :title,
            presence: { message: "can't be blank" },
            length: { maximum: 255, message: "is too long (maximum is 255 characters)" }

  validates :description,
            length: { maximum: 1000, message: "is too long (maximum is 1000 characters)" },
            allow_nil: true

  # ============================================
  # Callbacks
  # ============================================
  before_validation :strip_whitespace

  # ============================================
  # Scopes
  # ============================================
  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }

  # ============================================
  # Instance Methods
  # ============================================

  # Toggle completion status
  def toggle_completion!
    toggle!(:completed)
  end

  private

  # Strip whitespace from title before validation
  def strip_whitespace
    self.title = title.strip if title.present?
  end
end
