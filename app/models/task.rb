class Task < ApplicationRecord
  # Validations - Ensure data integrity
  validates :title, presence: { message: "cannot be blank" }
  validates :title, length: { maximum: 255, too_long: "must be less than 255 characters" }
  validates :description, length: { maximum: 1000, too_long: "must be less than 1000 characters" }

  # Default scope - Order by creation date (newest first)
  default_scope { order(created_at: :desc) }

  # Scopes - Reusable query methods
  scope :completed_tasks, -> { where(completed: true) }
  scope :incomplete_tasks, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }

  # Callback - Set default values
  before_validation :trim_title

  private

  # Clean Code: Small method with single responsibility
  def trim_title
    self.title = title.strip if title.present?
  end
end
