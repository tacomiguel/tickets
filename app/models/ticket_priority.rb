class TicketPriority < ApplicationRecord
  enum status: { disabled: 0, enabled: 1, deleted: 2 }

  validates :name, presence: true
  validates :priority, presence: true

  scope :active, -> { where.not(status: :deleted) }
  scope :select_options, -> { active.order(priority: :asc, created_at: :asc) }

  def soft_delete
    update(status: :deleted)
  end
end
